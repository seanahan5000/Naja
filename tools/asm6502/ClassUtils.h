
#pragma once

//------------------------------------------------------------------------------

// For array of structs:
//	typedef Array<SomeStruct> SomeStructArray;
//
// For array of pointers:
//	typedef Array<SomeClass*> SomeClassPtrArray;

template <class T>
class Array
{
public:
	Array(INT32 capacity = 0)
	{
		mCount = 0;
		mCapacity = capacity;
		mArray = (T*)realloc(NULL, mCapacity * sizeof(T));
	}

	~Array()
	{
		free(mArray);
	}

	void Add(T object)
	{
		if (mCount == mCapacity)
		{
			mCapacity += mCapacity ? mCapacity : 16;
			mArray = (T*)realloc(mArray, mCapacity * sizeof(T));
		}
		mArray[mCount++] = object;
	}

	void Trim()
	{
		mCapacity = mCount;
		mArray = (T*)realloc(mArray, mCapacity * sizeof(T));
	}

	void Clear()
	{
		mCount = 0;
	}

	void DeleteAll()
	{
		for (INT32 i = 0; i < mCount; ++i)
			delete mArray[i];

		Clear();
	}

	INT32 GetCount() { return mCount; }

	T& operator[](size_t index) const { return mArray[index]; }

protected:
	T* mArray;
	INT32 mCount;
	INT32 mCapacity;
};

//------------------------------------------------------------------------------

// For stack of structs:
//	typedef Stack<SomeStruct> SomeStructStack;
//
// For stack of pointers:
//	typedef Stack<SomeClass*> SomeClassPtrStack;

template <class T>
class Stack
{
public:
	Stack(INT32 capacity = 0)
	{
		mDepth = 0;
		mCapacity = capacity;
		mStack = (T*)realloc(NULL, mCapacity * sizeof(T));
	}

	~Stack()
	{
		free(mStack);
	}

	void Push(T object)
	{
		if (mDepth == mCapacity)
		{
			mCapacity += mCapacity ? mCapacity : 16;
			mStack = (T*)realloc(mStack, mCapacity * sizeof(T));
		}
		mStack[mDepth++] = object;
	}

	T& Pull()
	{
		return mStack[--mDepth];
	}

	T& Top()
	{
		return mStack[mDepth - 1];
	}

	void Clear()
	{
		mDepth = 0;
	}

	void DeleteAll()
	{
		for (INT32 i = 0; i < mDepth; ++i)
			delete mStack[i];

		Clear();
	}

	INT32 GetDepth() { return mDepth; }

protected:
	T* mStack;
	INT32 mDepth;
	INT32 mCapacity;
};

//------------------------------------------------------------------------------

class GrowBuffer
{
public:
	GrowBuffer(INT32 capacity = 0)
	{
		mAvailable = capacity;
		mConsumed = 0;
		mBuffer = (UINT8*)realloc(NULL, mConsumed + mAvailable);
	}

	~GrowBuffer()
	{
		free(mBuffer);
	}

	UINT8* GetPtr() { return mBuffer; }
	INT32 GetSize() { return mConsumed; }

	UINT8* MakeAvailable(INT32 count)
	{
		if (count > mAvailable)
		{
			mAvailable += mConsumed;
			if (mAvailable < count)
				mAvailable = count;

			mBuffer = (UINT8*)realloc(mBuffer, mConsumed + mAvailable);
		}
		return mBuffer + mConsumed;
	}

	void Consume(INT32 count)
	{
		mConsumed += count;
		mAvailable -= count;
	}

	void Trim()
	{
		mBuffer = (UINT8*)realloc(mBuffer, mConsumed);
		mAvailable = 0;
	}

	void Clear()
	{
		mAvailable += mConsumed;
		mConsumed = 0;
	}

protected:
	UINT8* mBuffer;
	INT32 mAvailable;
	INT32 mConsumed;
};

//------------------------------------------------------------------------------
