#include "catalog.h"
#include "query.h"
#include "heapfile.h"
#include <cstring>

/*
 * Deletes records from a specified relation.
 *
 * Returns:
 *      OK on success
 *      an error code otherwise
 */

const Status QU_Delete(const string &relation,
					   const string &attrName,
					   const Operator op,
					   const Datatype type,
					   const char *attrValue)
{
	// QU_Delete deletes records from a specified relation
	cout << "Doing QU_Delete " << endl;
	
	if (relation.empty())
	{
		return BADCATPARM;
	}

	// validate the relation exists
	RelDesc relDesc;
	Status status = relCat->getInfo(relation, relDesc);
	if (status != OK)
	{
		return status; // relation not found
	}

	// fetch the schema of the relation
	int attrCnt;
	AttrDesc *attributes = nullptr;
	status = attrCat->getRelInfo(relation, attrCnt, attributes);
	if (status != OK)
	{
		return status; // failed to retrieve schema
	}

	// locate the target attribute in the schema
	AttrDesc targetAttr;
	bool found = false;
	if (!attrName.empty())
	{
		for (int i = 0; i < attrCnt; ++i)
		{
			if (strcmp(attributes[i].attrName, attrName.c_str()) == 0)
			{
				targetAttr = attributes[i];
				found = true;
				break;
			}
		}

		if (!found)
		{
			delete[] attributes;
			return ATTRNOTFOUND; // attribute not found
		}
	}

	// open a HeapFileScan for the relation
	HeapFileScan fileScan(relation, status);
	if (status != OK)
	{
		delete[] attributes;
		return status; // failed to initialize HeapFileScan
	}

	// set the filter condition
	bool conditional = (attrValue != nullptr);
	while (true)
	{
		if (conditional)
		{
			if (type == INTEGER)
			{
				int intValue = atoi(attrValue);
				fileScan.startScan(targetAttr.attrOffset, targetAttr.attrLen, (Datatype)type, (char *)&intValue, op);
			}
			else if (type == FLOAT)
			{
				float floatValue = atof(attrValue);
				fileScan.startScan(targetAttr.attrOffset, targetAttr.attrLen, (Datatype)type, (char *)&floatValue, op);
			}
			else if (type == STRING)
			{
				fileScan.startScan(targetAttr.attrOffset, targetAttr.attrLen, (Datatype)type, attrValue, op);
			}
			else
			{
				delete[] attributes;
				return ATTRTYPEMISMATCH;
			}
		}
		else
		{
			// unconditional scan
			fileScan.startScan(0, 0, (Datatype)0, nullptr, (Operator)0);
		}

		// scan and delete matching records
		RID recordId;
		bool deleted = false;
		while (fileScan.scanNext(recordId) == OK)
		{
			status = fileScan.deleteRecord();
			if (status != OK)
			{
				delete[] attributes;
				return status; // failed to delete record
			}
			deleted = true;
		}

		// end the scan
		fileScan.endScan();

		// if no more records there to be deleted, break
		if (!deleted)
		{
			break;
		}
	}

	// clean up and return
	delete[] attributes;
	return OK;
}
