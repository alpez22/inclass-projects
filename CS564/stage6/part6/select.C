#include "catalog.h"
#include "heapfile.h"
#include "query.h"

// forward declaration
const Status ScanSelect(const string &result,
						const int projCnt,
						const AttrDesc projNames[],
						const AttrDesc *attrDesc,
						const Operator op,
						const char *filter,
						const int reclen);

/*
 * Selects records from the specified relation.
 *
 * Returns:
 * 	OK on success
 * 	an error code otherwise
 */

const Status QU_Select(const string &result,
					   const int projCnt,
					   const attrInfo projNames[],
					   const attrInfo *attr,
					   const Operator op,
					   const char *attrValue)
{
	// Qu_Select sets up things and then calls ScanSelect to do the actual work
	cout << "Doing QU_Select " << endl;

	AttrDesc projDesc[projCnt];
	for (int i = 0; i < projCnt; i++)
	{
		Status s = attrCat->getInfo(projNames[i].relName, projNames[i].attrName, projDesc[i]);
		if (s != OK)
			return s;
	}

	AttrDesc *attrDescPtr = NULL;
	char filterVal[MAXSTRINGLEN];

	if (attr != NULL)
	{
		AttrDesc temp;
		Status s = attrCat->getInfo(attr->relName, attr->attrName, temp);
		if (s != OK)
			return s;

		attrDescPtr = new AttrDesc(temp);

		switch (attrDescPtr->attrType)
		{
		case INTEGER:
		{
			int val = atoi(attrValue);
			memcpy(filterVal, &val, sizeof(int));
			break;
		}
		case FLOAT:
		{
			float fval = (float)atof(attrValue);
			memcpy(filterVal, &fval, sizeof(float));
			break;
		}
		case STRING:
		{
			strcpy(filterVal, attrValue);
			break;
		}
		}
	}

	int recordLen = 0;
	for (int i = 0; i < projCnt; i++)
	{
		recordLen += projDesc[i].attrLen;
	}
	return ScanSelect(result, projCnt, projDesc, attrDescPtr, op, (attr ? filterVal : NULL), recordLen);
}

const Status ScanSelect(const string &result,
#include "stdio.h"
#include "stdlib.h"
						const int projCnt,
						const AttrDesc projNames[],
						const AttrDesc *attrDesc,
						const Operator op,
						const char *filter,
						const int reclen)
{
	cout << "Doing HeapFileScan Selection using ScanSelect()" << endl;

	Status status;
	string inputRelName = projNames[0].relName;

	HeapFileScan heapFileScan(inputRelName, status);
	if (status != OK)
		return status;

	// Start the scan with or without a filter
	if (attrDesc)
	{
		status = heapFileScan.startScan(attrDesc->attrOffset,
										attrDesc->attrLen,
										(Datatype)attrDesc->attrType,
										filter,
										op);
	}
	else
	{
		status = heapFileScan.startScan(0, 0, STRING, NULL, EQ);
	}
	if (status != OK)
		return status;

	InsertFileScan insertFileScan(result, status);
	if (status != OK)
	{
		heapFileScan.endScan();
		return status;
	}

	RID rid;
	Record record;

	while ((status = heapFileScan.scanNext(rid)) == OK)
	{
		status = heapFileScan.getRecord(record);
		if (status != OK)
		{
			heapFileScan.endScan();
			return status;
		}

		char *outRec = new char[reclen];
		int offset = 0;
		for (int i = 0; i < projCnt; i++)
		{
			memcpy(outRec + offset,
				   ((char *)record.data) + projNames[i].attrOffset,
				   projNames[i].attrLen);
			offset += projNames[i].attrLen;
		}

		Record newRec;
		newRec.data = outRec;
		newRec.length = reclen;

		RID newRid;
		status = insertFileScan.insertRecord(newRec, newRid);
		delete[] outRec;

		if (status != OK)
		{
			heapFileScan.endScan();
			return status;
		}
	}

	if (status != FILEEOF)
	{
		heapFileScan.endScan();
		return status;
	}

	status = heapFileScan.endScan();
	return status;
}
