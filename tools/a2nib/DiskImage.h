
#pragma once

//------------------------------------------------------------------------------

struct VTS
{
	UINT8 volume;
	UINT8 track;
	UINT8 sector;
	UINT8 unused;
};


class DiskImage
{
public:
	DiskImage();
	virtual ~DiskImage();

	bool Open(const char* fileName, bool create);
	bool Close();

	void Initialize(INT32 v = 254);
	bool Write(VTS vts, const UINT8* src, INT32 length);
	bool Read(VTS vts, UINT8* dst, INT32 length);

protected:
	UINT8* LogicalToPhysicalSectorPtr(VTS vts);

	void InitializeLogicalSector(VTS vts);
	void WriteLogicalSector(VTS vts, const UINT8* src);
	UINT8* WriteSectorProlog(UINT8* p, VTS vts);
	UINT8* WriteSectorEpilog(UINT8* p, VTS vts);
	UINT8* WriteSyncBytes(UINT8* p, VTS vts, INT32 count);
	UINT8* WriteOddEven(UINT8* p, INT32 n);

	bool ReadLogicalSector(VTS vts, UINT8* dst);

	INT32 SectorLogicalToPhysical(VTS vts);

	virtual const UINT8* GetPhysicalInterleave(VTS vts);
	virtual const UINT8* GetLogicalInterleave(VTS vts);
	virtual const UINT8* GetWriteTranslateTable(VTS vts);
	virtual UINT8 GetSyncValue(VTS vts) { return 0xFF; }

	virtual UINT8* WriteAddressField(UINT8* p, VTS vts);
	virtual UINT8* WriteDataFieldProlog(UINT8* p, VTS vts);
	virtual UINT8* WriteDataFieldEpilog(UINT8* p, VTS vts);

	FILE* mFile;
	UINT8* mImage;
};

//------------------------------------------------------------------------------

class Dos33Image : public DiskImage
{
public:
	Dos33Image() {}

protected:
	const UINT8* GetLogicalInterleave(VTS vts);
};

//------------------------------------------------------------------------------

class ProDosImage : public DiskImage
{
public:
	ProDosImage() {}

protected:
	const UINT8* GetLogicalInterleave(VTS vts);
};

//------------------------------------------------------------------------------

class NajaImage : public DiskImage
{
public:
	NajaImage() {}

protected:
	const UINT8* GetPhysicalInterleave(VTS vts);
	const UINT8* GetWriteTranslateTable(VTS vts);
	UINT8 GetSyncValue(VTS vts);

	UINT8* WriteEvenOdd(UINT8* p, INT32 n);
	UINT8* WriteAddressField(UINT8* p, VTS vts);
	UINT8* WriteDataFieldProlog(UINT8* p, VTS vts);
	UINT8* WriteDataFieldEpilog(UINT8* p, VTS vts);
};

//------------------------------------------------------------------------------

class Naja2Image : public DiskImage
{
public:
	Naja2Image() {}

protected:
	const UINT8* GetLogicalInterleave(VTS vts);
};

//------------------------------------------------------------------------------

