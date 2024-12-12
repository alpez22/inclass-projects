#include "catalog.h"
#include "query.h"
#include "heapfile.h"
#include <cstring>
#include <cstdlib>

/*
 * Inserts a record into the specified relation.
 *
 * Returns:
 *      OK on success
 *      an error code otherwise
 */

const Status QU_Insert(const string &relation, const int attributeCount, const attrInfo attributes[])
{
    // QU_Insert inserts a record into the specified relation
    cout << "Doing QU_Insert " << endl;

    // fetch relation schema information
    AttrDesc *attrs = nullptr;
    int schemaAttributeCount = 0;
    Status status = attrCat->getRelInfo(relation, schemaAttributeCount, attrs);
    if (status != OK)
    {
        return status; // failed to retrieve schema
    }

    // calculate total record length
    int totalRecordSize = 0;
    for (int i = 0; i < schemaAttributeCount; ++i)
    {
        totalRecordSize += attrs[i].attrLen;
    }

    // allocate memory for the record
    char *recordBuffer = new char[totalRecordSize];
    if (!recordBuffer)
    {
        delete[] attrs;
        return INSUFMEM; // memory allocation failure
    }
    memset(recordBuffer, 0, totalRecordSize); // initialize buffer to zero

    // populate the record buffer
    for (int i = 0; i < schemaAttributeCount; ++i)
    {
        bool foundMatch = false;
        for (int j = 0; j < attributeCount; ++j)
        {
            if (strcmp(attrs[i].attrName, attributes[j].attrName) == 0)
            {
                foundMatch = true;

                // copy data based on attribute type
                if (attrs[i].attrType == INTEGER)
                {
                    int intValue = atoi((char *)attributes[j].attrValue);
                    memcpy(recordBuffer + attrs[i].attrOffset, &intValue, attrs[i].attrLen);
                }
                else if (attrs[i].attrType == FLOAT)
                {
                    float floatValue = atof((char *)attributes[j].attrValue);
                    memcpy(recordBuffer + attrs[i].attrOffset, &floatValue, attrs[i].attrLen);
                }
                else
                {
                    memcpy(recordBuffer + attrs[i].attrOffset, attributes[j].attrValue, attrs[i].attrLen);
                }
                break;
            }
        }

        if (!foundMatch)
        {
            delete[] recordBuffer;
            delete[] attrs;
            return ATTRNOTFOUND; // attribute not found in input
        }
    }

    // insert the record into the relation
    InsertFileScan fileScan(relation, status);
    if (status != OK)
    {
        delete[] recordBuffer;
        delete[] attrs;
        return status; // failed to initialize InsertFileScan
    }

    // construct a Record object for insertion
    Record newRecord;
    newRecord.data = recordBuffer;
    newRecord.length = totalRecordSize;

    // declare an RID object for the inserted record
    RID insertedRecordId;

    // insert the record
    status = fileScan.insertRecord(newRecord, insertedRecordId);

    delete[] recordBuffer;
    delete[] attrs;

    return status;
}
