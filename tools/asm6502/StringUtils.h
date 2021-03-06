
#pragma once

//------------------------------------------------------------------------------

struct HashEntry
{
	HashEntry* next;
	UINT32 key;
	void* object;
	char string[1];
};


class StringHash
{
public:
	StringHash(UINT32 size = 1024);
	~StringHash();

	bool Add(const char* string, void* object);
	bool AddNoCase(const char* string, void* object);
	void* Find(const char* string);

    INT32 GetEntryCount() { return mCount; }
    void GetEntries(HashEntry** entries);

protected:
	UINT32 GenerateKey(const char* string);

    UINT32 mCount;
	UINT32 mSize;
	HashEntry** mEntries;
};

//------------------------------------------------------------------------------
