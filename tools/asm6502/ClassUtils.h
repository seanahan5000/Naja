
#pragma once

//------------------------------------------------------------------------------

class GrowBuffer
{
public:
	GrowBuffer(INT32 capacity = 0)
	{
		mAvailable = capacity;
		mConsumed = 0;
		mBuffer = (UINT8*)realloc(nullptr, mConsumed + mAvailable);
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
