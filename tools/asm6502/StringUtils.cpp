
#include "precomp.h"
#include "StringUtils.h"

//------------------------------------------------------------------------------

StringArray::StringArray(INT32 capacity)
{
	mCount = 0;
	mCapacity = capacity;
	mStrings = (char**)realloc(NULL,capacity * sizeof(char*));
}


StringArray::~StringArray()
{
	for (INT32 i = 0; i < mCount; ++i)
		free(mStrings[i]);
}


INT32
StringArray::Add(const char* string)
{
	if (mCount >= mCapacity)
	{
		mCapacity += mCapacity;
		if (mCapacity == 0)
			mCapacity = 8;
		mStrings = (char**)realloc(mStrings,mCapacity * sizeof(char*));
	}
	mStrings[mCount++] = strdup(string);
	return mCount - 1;
}

//------------------------------------------------------------------------------

StringHash::StringHash(UINT32 size)
{
	mSize = size;
	INT32 byteCount = sizeof(HashEntry*) * size;
	mEntries = (HashEntry**)malloc(byteCount);
	memset(mEntries,0,byteCount);
}


StringHash::~StringHash()
{
	for (UINT32 i = 0; i < mSize; ++i)
	{
		HashEntry* entry = NULL;
		HashEntry* next = mEntries[i];
		while (next)
		{
			entry = next;
			next = entry->next;
			free(entry);
		}
	}
	free(mEntries);
}


bool
StringHash::Add(const char* string,void* object)
{
	UINT32 key = GenerateKey(string);
	INT32 index = key % mSize;
	
	HashEntry* entry = mEntries[index];
	while (entry)
	{
		if (entry->key == key)
		{
			// case sensitive
			if (strcmp(entry->string,string) == 0)
				return false;
		}
		entry = entry->next;
	}
	
	entry = (HashEntry*)malloc(sizeof(HashEntry) + strlen(string));
	entry->key = key;
	entry->object = object;
	strcpy(entry->string,string);
	entry->next = mEntries[index];
	mEntries[index] = entry;
	return true;
}


bool
StringHash::AddNoCase(const char* string,void* object)
{
	char* sp = strdup(string);
	char* cp;
	char c;
	bool result;
	
	cp = sp;
	do {
		c = *cp;
		*cp++ = tolower(c);
	} while (c != 0);
	
	result = Add(sp,object);
	
	if (result)
	{
		cp = sp;
		do {
			c = *cp;
			*cp++ = toupper(c);
		} while (c != 0);
		
		result = Add(sp,object);
	}
	
	free(sp);
	return result;
}


void*
StringHash::Find(const char* string)
{
	UINT32 key = GenerateKey(string);
	INT32 index = key % mSize;
	
	HashEntry* entry = mEntries[index];
	while (entry)
	{
		if (entry->key == key)
		{
			// case sensitive
			if (strcmp(entry->string,string) == 0)
				return entry->object;
		}
		entry = entry->next;
	}
	
	return NULL;
}


UINT32
StringHash::GenerateKey(const char* string)
{
	UINT32 key = 0;
	const UINT8* sp = (const UINT8*)string;
	UINT8 c;
	while ((c = *sp++) != 0)
		key = (key << 5) - key + c;
	return key;
}

//------------------------------------------------------------------------------