#include <ctime>
#include <filesystem>
#include <functional>
#include <memory.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <fcntl.h>
#include <iostream>
#include <stdio.h>
#include "error.h"
#include "page.h"
#include "buf.h"

#define ASSERT(c)  { if (!(c)) { \
		       cerr << "At line " << __LINE__ << ":" << endl << "  "; \
                       cerr << "This condition should hold: " #c << endl; \
                       exit(1); \
		     } \
                   }

//----------------------------------------
// Constructor of the class BufMgr
//----------------------------------------

BufMgr::BufMgr(const int bufs)
{
    numBufs = bufs;

    bufTable = new BufDesc[bufs];
    memset(bufTable, 0, bufs * sizeof(BufDesc));
    for (int i = 0; i < bufs; i++) 
    {
        bufTable[i].frameNo = i;
        bufTable[i].valid = false;
    }

    bufPool = new Page[bufs];
    memset(bufPool, 0, bufs * sizeof(Page));

    int htsize = ((((int) (bufs * 1.2))*2)/2)+1;
    hashTable = new BufHashTbl (htsize);  // allocate the buffer hash table

    clockHand = bufs - 1;
}


BufMgr::~BufMgr() {

    // flush out all unwritten pages
    for (int i = 0; i < numBufs; i++) 
    {
        BufDesc* tmpbuf = &bufTable[i];
        if (tmpbuf->valid == true && tmpbuf->dirty == true) {

#ifdef DEBUGBUF
            cout << "flushing page " << tmpbuf->pageNo
                 << " from frame " << i << endl;
#endif

            tmpbuf->file->writePage(tmpbuf->pageNo, &(bufPool[i]));
        }
    }

    delete [] bufTable;
    delete [] bufPool;
}


const Status BufMgr::allocBuf(int & frame) 
{
    int framesPinned = 0;
    while (framesPinned < numBufs) {
        BufDesc* tmpbuf = &bufTable[clockHand];

        if (!tmpbuf->valid) {
            tmpbuf->Clear();
            frame = clockHand;
            advanceClock();
            return OK;
        }

        if (tmpbuf->refbit) {
            tmpbuf->refbit = false;
        } else if (tmpbuf->pinCnt != 0){
            framesPinned++;
        } else {
            if (tmpbuf->dirty) {
                Status writeStat = tmpbuf->file->writePage(tmpbuf->pageNo, &bufPool[clockHand]);
                if (writeStat != OK) {
                    return UNIXERR;
                } 
                tmpbuf->dirty = false;
            }
            hashTable->remove(tmpbuf->file, tmpbuf->pageNo);
            tmpbuf->Clear();
            frame = clockHand;
            advanceClock();
            return OK;
        }
        advanceClock();
    }
    return BUFFEREXCEEDED;
}

	
const Status BufMgr::readPage(File* file, const int PageNo, Page*& page)
{
    int frameNo;
    Status hashStat = hashTable->lookup(file, PageNo, frameNo);
   
    // CASE 1)
    if (hashStat == HASHNOTFOUND) {
        if (Status allocStat = allocBuf(frameNo); allocStat != OK){
            return allocStat;
        }
        Status readStat = file->readPage(PageNo, &bufPool[frameNo]);
        if (readStat != OK) {
            bufTable[frameNo].Clear();
            return readStat;
        }
        Status insertStat = hashTable->insert(file, PageNo, frameNo);
        if (insertStat != OK) {
            bufTable[frameNo].Clear();
            return insertStat;
        }
        bufTable[frameNo].Set(file, PageNo);
        page = &bufPool[frameNo];
        return OK;
    }
    // CASE 2)
    BufDesc* tmpbuf = &bufTable[frameNo];
    tmpbuf->refbit = true;
    tmpbuf->pinCnt++;
    page = &bufPool[frameNo];
    return OK;
}


const Status BufMgr::unPinPage(File* file, const int PageNo, 
			       const bool dirty) 
{
    int frameNo;
    Status hashStat = hashTable->lookup(file, PageNo, frameNo);
    if (hashStat != OK) {
        return hashStat;
    }
    BufDesc* tmpbuf = &bufTable[frameNo];
    if (tmpbuf->pinCnt == 0) {
        return PAGENOTPINNED;
    }
    tmpbuf->pinCnt--;
    if (dirty){
        tmpbuf->dirty = true;
    }
    return OK;
}

const Status BufMgr::allocPage(File* file, int& pageNo, Page*& page) 
{
    if (Status pageStat = file->allocatePage(pageNo); pageStat != OK) {
        return pageStat;
    }
    int frameNo; 
    if (Status allocStat = allocBuf(frameNo); allocStat != OK){
        return allocStat;
    }
    Status insertStat = hashTable->insert(file, pageNo, frameNo);
    if (insertStat != OK) {
        return insertStat;
    }
    bufTable[frameNo].Set(file, pageNo);
    page = &bufPool[frameNo];
    return OK;
}

const Status BufMgr::disposePage(File* file, const int pageNo) 
{
    // see if it is in the buffer pool
    Status status = OK;
    int frameNo = 0;
    status = hashTable->lookup(file, pageNo, frameNo);
    if (status == OK)
    {
        // clear the page
        bufTable[frameNo].Clear();
    }
    status = hashTable->remove(file, pageNo);

    // deallocate it in the file
    return file->disposePage(pageNo);
}

const Status BufMgr::flushFile(const File* file) 
{
  Status status;

  for (int i = 0; i < numBufs; i++) {
    BufDesc* tmpbuf = &(bufTable[i]);
    if (tmpbuf->valid == true && tmpbuf->file == file) {

      if (tmpbuf->pinCnt > 0)
	  return PAGEPINNED;

      if (tmpbuf->dirty == true) {
#ifdef DEBUGBUF
	cout << "flushing page " << tmpbuf->pageNo
             << " from frame " << i << endl;
#endif
    if ((status = tmpbuf->file->writePage(tmpbuf->pageNo,
                    &(bufPool[i]))) != OK)
	  return status;
    

	tmpbuf->dirty = false;
      }

      hashTable->remove(file,tmpbuf->pageNo);

      tmpbuf->file = NULL;
      tmpbuf->pageNo = -1;
      tmpbuf->valid = false;
    }

    else if (tmpbuf->valid == false && tmpbuf->file == file)
      return BADBUFFER;
  }
  
  return OK;
}


void BufMgr::printSelf(void) 
{
    BufDesc* tmpbuf;
  
    cout << endl << "Print buffer...\n";
    for (int i=0; i<numBufs; i++) {
        tmpbuf = &(bufTable[i]);
        cout << i << "\t" << (char*)(&bufPool[i]) 
             << "\tpinCnt: " << tmpbuf->pinCnt;
    
        if (tmpbuf->valid == true)
            cout << "\tvalid\n";
        cout << endl;
    };
}


