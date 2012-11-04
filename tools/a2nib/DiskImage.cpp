
#include <windows.h>
#include <stdio.h>
#include "DiskImage.h"

static const INT32 kBytesPerDisk = 232960;
static const INT32 kBytesPerTrack = kBytesPerDisk / 35;		// 6656
static const INT32 kBytesPerSector = 396;	//kBytesPerTrack / 16;	//  416

static const INT32 kSyncLeadIn = 48;
static const INT32 kSyncLeadOut = 272;

C_ASSERT(kSyncLeadIn + kBytesPerSector * 16 + kSyncLeadOut == kBytesPerTrack);

static const INT32 kAddressFieldSize = 14;
static const INT32 kPreDataSyncCount = 6;
static const INT32 kDataPrologSize = 3;
static const INT32 kDataEpilogSize = 3;
static const INT32 kEndSyncCount = 27;

C_ASSERT(kAddressFieldSize + kPreDataSyncCount + kDataPrologSize +
		 342 + 1 + kDataEpilogSize + kEndSyncCount == kBytesPerSector);

static const INT32 kSectorDataOffset = kAddressFieldSize +
									   kPreDataSyncCount +
									   kDataPrologSize;

//------------------------------------------------------------------------------

DiskImage::DiskImage()
{
	mFile = NULL;
	mImage = NULL;
}


DiskImage::~DiskImage()
{
	if (mFile)
		Close();
	if (mImage)
		delete [] mImage;
}


bool
DiskImage::Open(const char* fileName,bool create)
{
	mFile = fopen(fileName,create ? "wb+" : "rb+");
	if (!mFile)
		return false;
	
	if (!create)
	{
		if (fread(mImage,1,kBytesPerDisk,mFile) != kBytesPerDisk)
		{
			printf("Invalid file size\n");
			return false;
		}
	}
	
	mImage = new UINT8[kBytesPerDisk];
	return true;
}


bool
DiskImage::Close()
{
	if (mFile)
	{
		if (fwrite(mImage,1,kBytesPerDisk,mFile) != kBytesPerDisk)
			return false;
		
		fclose(mFile);
		mFile = NULL;
	}
	return true;
}


void
DiskImage::Initialize(INT32 v)
{
	VTS vts;
	vts.volume = v;
	
	for (INT32 t = 0; t < 35; ++t)
	{
		WriteSyncBytes(mImage + t * kBytesPerTrack,kSyncLeadIn);
		
		vts.track = t;
		for (INT32 s = 0; s < 16; ++s)
		{
			vts.sector = s;
			InitializePhysicalSector(vts);
		}
		
		WriteSyncBytes(mImage + (t + 1) * kBytesPerTrack - kSyncLeadOut,kSyncLeadOut);
	}
}


bool
DiskImage::Write(VTS vts,UINT8* src,INT32 length)
{
	while (length > 0)
	{
		WriteLogicalSector(vts,src);
		src += 256;
		length -= 256;
		
		if (++vts.sector == 16)
		{
			if (++vts.track == 35)
			{
				printf("Writing off end of disk\n");
				return false;
			}
		}
	}
	return true;
}

//------------------------------------------------------------------------------

UINT8*
DiskImage::GetPhysicalSectorPtr(VTS vts)
{
	vts.sector = GetPhysicalInterleave(vts)[vts.sector];
	
	return mImage + vts.track * kBytesPerTrack + kSyncLeadIn +
		vts.sector * kBytesPerSector;
}


UINT8*
DiskImage::GetLogicalSectorPtr(VTS vts)
{
	vts.sector = GetLogicalInterleave(vts)[vts.sector];
	return GetPhysicalSectorPtr(vts);
}


void
DiskImage::InitializePhysicalSector(VTS vts)
{
	UINT8* p = GetPhysicalSectorPtr(vts);
	p = WriteSectorProlog(p,vts);
	memset(p,0x96,342);
	p += 342;
	*p++ = 0;
	WriteSectorEpilog(p,vts);
}


// Given 256 bytes of data in src, nibblize 343 bytes into dst.

void
DiskImage::WriteLogicalSector(VTS vts,UINT8* src)
{
	UINT8* dst = GetLogicalSectorPtr(vts) + kSectorDataOffset;
	UINT8 dbuffer[342];

	INT32 i;
	
	memset(dbuffer + 256,0,342 - 256);
	
	// split into 6 and 2
	INT32 j = 256 + 2;
	for (i = 256; --i >= 0; )
	{
		UINT8 byte = src[i];
		UINT8 bit;
		
		bit = byte & 1;
		byte >>= 1;
		dbuffer[j] = (dbuffer[j] << 1) | bit;
		
		bit = byte & 1;
		byte >>= 1;
		dbuffer[j] = (dbuffer[j] << 1) | bit;
		
		dbuffer[i ^ 255] = byte;
		
		if (++j == 342)
			j = 256;
	}
	
	// translate and checksum
	const UINT8* writeTranslate = GetWriteTranslateTable(vts);
	UINT8 last = 0;
	UINT8* dp = dst;
	for (i = 342; --i >= 0; )
	{
		UINT8 value = dbuffer[i];
		*dp++ = writeTranslate[value ^ last];
		last = value;
	}
	*dp++ = writeTranslate[last];
}


UINT8*
DiskImage::WriteSectorProlog(UINT8* p,VTS vts)
{
	p = WriteAddressField(p,vts);
	p = WriteSyncBytes(p,kPreDataSyncCount);
	p = WriteDataFieldProlog(p,vts);
	return p;
}


UINT8*
DiskImage::WriteSectorEpilog(UINT8* p,VTS vts)
{
	p = WriteDataFieldEpilog(p,vts);
	p = WriteSyncBytes(p,kEndSyncCount);
	return p;
}


UINT8*
DiskImage::WriteSyncBytes(UINT8* p,INT32 count,UINT8 value)
{
	memset(p,value,count);
	p += count;
	return p;
}


UINT8*
DiskImage::WriteEvenOdd(UINT8* p,INT32 n)
{
	*p++ = (n >> 1) | 0xAA;
	*p++ = (n >> 0) | 0xAA;
	return p;
}

//------------------------------------------------------------------------------

/*virtual*/ const UINT8*
DiskImage::GetPhysicalInterleave(VTS vts)
{
	static const UINT8 sNoPhysicalInterleave[16] =
	{
		0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7,
		0x8,0x9,0xA,0xB,0xC,0xD,0xE,0xF
	};
	return sNoPhysicalInterleave;
}


/*virtual*/ const UINT8*
DiskImage::GetLogicalInterleave(VTS vts)
{
	static const UINT8
	sNoLogicalInterleave[16] =
	{
		0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7,
		0x8,0x9,0xA,0xB,0xC,0xD,0xE,0xF
	};
	return sNoLogicalInterleave;
}


/*virtual*/ const UINT8*
DiskImage::GetWriteTranslateTable(VTS vts)
{
	static const UINT8
	sWriteTranslateTable[0x40] =
	{
		0x96,0x97,0x9A,0x9B,0x9D,0x9E,0x9F,0xA6,
		0xA7,0xAB,0xAC,0xAD,0xAE,0xAF,0xB2,0xB3,
		0xB4,0xB5,0xB6,0xB7,0xB9,0xBA,0xBB,0xBC,
		0xBD,0xBE,0xBF,0xCB,0xCD,0xCE,0xCF,0xD3,
		0xD6,0xD7,0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,
		0xDF,0xE5,0xE6,0xE7,0xE9,0xEA,0xEB,0xEC,
		0xED,0xEE,0xEF,0xF2,0xF3,0xF4,0xF5,0xF6,
		0xF7,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF
	};
	
	return sWriteTranslateTable;
}


const UINT8*
Dos33Image::GetLogicalInterleave(VTS vts)
{
	static const UINT8
	sDos33LogicalInterleave[16] =
	{
		0x0,0x7,0xE,0x6,0xD,0x5,0xC,0x4,
		0xB,0x3,0xA,0x2,0x9,0x1,0x8,0xF
	};
	//*** different for track 0??? ***
	return sDos33LogicalInterleave;
}


const UINT8*
ProDosImage::GetLogicalInterleave(VTS vts)
{
	static const UINT8
	sProDosLogicalInterleave[16] =
	{
		0x0,0x8,0x1,0x9,0x2,0xA,0x3,0xB,
		0x4,0xC,0x5,0xD,0x6,0xE,0x7,0xF
	};
	return sProDosLogicalInterleave;
}

//------------------------------------------------------------------------------

/*virtual*/ UINT8*
DiskImage::WriteAddressField(UINT8* p,VTS vts)
{
	*p++ = 0xD5;
	*p++ = 0xAA;
	*p++ = 0x96;
	
	p = WriteEvenOdd(p,vts.volume);
	p = WriteEvenOdd(p,vts.track);
	p = WriteEvenOdd(p,vts.sector);
	p = WriteEvenOdd(p,vts.volume ^ vts.track ^ vts.sector);
	
	*p++ = 0xDE;
	*p++ = 0xAA;
	*p++ = 0xEB;
	return p;
}


/*virtual*/ UINT8*
DiskImage::WriteDataFieldProlog(UINT8* p,VTS vts)
{
	*p++ = 0xD5;
	*p++ = 0xAA;
	*p++ = 0xAD;
	return p;
}


/*virtual*/ UINT8*
DiskImage::WriteDataFieldEpilog(UINT8* p,VTS vts)
{
	*p++ = 0xDE;
	*p++ = 0xAA;
	*p++ = 0xEB;
	return p;
}

//------------------------------------------------------------------------------

const UINT8*
NajaImage::GetPhysicalInterleave(VTS vts)
{
	static const UINT8
	sNajaPhysicalInterleave[16] =
	{
		0x0,0x8,0x1,0x9,0x2,0xA,0x3,0xB,
		0x4,0xC,0x5,0xD,0x6,0xE,0x7,0xF
	};
	//*** same physical interleave on all sides, tracks? ***
	return sNajaPhysicalInterleave;
}


const UINT8*
NajaImage::GetWriteTranslateTable(VTS vts)
{
	// On the boot disk, the first two sectors of
	//	the first track are standard DOS 3.3 format.
	if (vts.volume == 0 && vts.track == 0)
	{
		if (vts.sector == 0 || vts.sector == 1)
			return DiskImage::GetWriteTranslateTable(vts);
	}
	
	static const UINT8
	sNajaWriteTranslateTable[0x40] =
	{
		0xFF,0xFE,0xFD,0xFC,0xFB,0xFA,0xF9,0xF7,
		0xF6,0xF5,0xF4,0xF3,0xF2,0xAF,0xAE,0xAD,
		0xAC,0xAB,0xAA,0xA7,0xA6,0xCF,0xCE,0xCB,
		0xEF,0xEE,0xED,0xEC,0xEB,0xEA,0xE9,0xE7,
		0xE6,0xE5,0xDF,0xDE,0xDD,0xDB,0xDA,0xD9,
		0xD7,0xD6,0xD5,0xD3,0xBF,0xBE,0xBD,0xBC,
		0xBB,0xBA,0xB9,0xB7,0xB6,0xB5,0xB4,0xB3,
		0xB2,0x9F,0x9E,0x9D,0x9B,0x9A,0x97,0x96
	};
	
	return sNajaWriteTranslateTable;
}


UINT8*
NajaImage::WriteAddressField(UINT8* p,VTS vts)
{
	// On the boot disk, the first two sectors of
	//	the first track are standard DOS 3.3 format.
	if (vts.volume == 0 && vts.track == 0)
	{
		if (vts.sector == 0 || vts.sector == 1)
			return DiskImage::WriteAddressField(p,vts);
	}
	
	*p++ = 0xDC;
	*p++ = 0xFF;	//*** disk side??? ***
	*p++ = 0xCD;
	
	p = WriteEvenOdd(p,vts.sector);
	
	// the address field is shorter than the standard
	//	format, so pad it out with sync bytes
	return WriteSyncBytes(p,4 + 3);
	
//	p = WriteEvenOdd(p,vts.volume);
//	p = WriteEvenOdd(p,vts.track);
//	p = WriteEvenOdd(p,vts.volume ^ vts.track ^ vts.sector);
	
//	*p++ = 0xDE;
//	*p++ = 0xAA;
//	*p++ = 0xEB;
	return p;
}


UINT8*
NajaImage::WriteDataFieldProlog(UINT8* p,VTS vts)
{
	// On the boot disk, the first two sectors of
	//	the first track are standard DOS 3.3 format.
	if (vts.volume == 0 && vts.track == 0)
	{
		if (vts.sector == 0 || vts.sector == 1)
			return DiskImage::WriteDataFieldProlog(p,vts);
	}
	
	*p++ = 0xCD;
	*p++ = 0xFF;
	*p++ = 0xDC;
	return p;
}


UINT8*
NajaImage::WriteDataFieldEpilog(UINT8* p,VTS vts)
{
	// On the boot disk, the first two sectors of
	//	the first track are standard DOS 3.3 format.
	if (vts.volume == 0 && vts.track == 0)
	{
		if (vts.sector == 0 || vts.sector == 1)
			return DiskImage::WriteDataFieldEpilog(p,vts);
	}
	
	// there is no data epilog so just write sync bytes
	return WriteSyncBytes(p,3);
}

//------------------------------------------------------------------------------
