
#pragma once

//------------------------------------------------------------------------------

typedef bool (*FileEntryProc)(UINT8* fileEntryPtr,void* context);

class Dos33
{
public:
	Dos33();
	~Dos33();
	
	bool Open(const char* fileName,bool create);
	bool Close();
	
	void Format();
	void Catalog();
	bool Delete(const char* fileName);
	bool Bsave(const char* fileName,INT32 address,INT32 length,UINT8* data);
	
protected:
	UINT8* GetTrackSector(INT32 track,INT32 sector)
	{
		return mImage + (track * 16 + sector) * 256;
	}
	
	UINT8* GetVTOC()
	{
		return GetTrackSector(17,0);
	}
	
	void DeleteFileEntry(UINT8* fileEntry);
	
	UINT8* ForEachAllocatedFileEntry(FileEntryProc proc,void* context);
	UINT8* ForEachFreeFileEntry(FileEntryProc proc,void* context);
	
	UINT8* FindFileEntry(UINT8* name30);
	UINT8* FindFileEntry(const char* fileName);
	void PrepareFileName(UINT8* name30,const char* fileName);
	
	INT32 CountFreeSectors();
	UINT8* GetAllocationByteAndMask(INT32 track,INT32 sector,UINT8* mask);
	UINT8* AllocateSector(UINT8* ptrack,UINT8* psector);
	bool AllocateTrackSector(INT32 track,INT32 sector);
	bool FreeTrackSector(INT32 track,INT32 sector);
	
	FILE* mFile;
	UINT8* mImage;
};

//------------------------------------------------------------------------------
