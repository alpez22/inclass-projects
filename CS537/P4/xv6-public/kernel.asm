
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 14 15 80       	mov    $0x801514d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 86 10 80       	push   $0x80108640
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 a5 46 00 00       	call   80104700 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 86 10 80       	push   $0x80108647
80100097:	50                   	push   %eax
80100098:	e8 33 45 00 00       	call   801045d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 07 48 00 00       	call   801048f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 29 47 00 00       	call   80104890 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 44 00 00       	call   80104610 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 86 10 80       	push   $0x8010864e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 44 00 00       	call   801046b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 86 10 80       	push   $0x8010865f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 44 00 00       	call   801046b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 44 00 00       	call   80104670 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 d0 46 00 00       	call   801048f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 22 46 00 00       	jmp    80104890 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 86 10 80       	push   $0x80108666
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801002a0:	e8 4b 46 00 00       	call   801048f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 0f 11 80       	push   $0x80110f20
801002c8:	68 00 0f 11 80       	push   $0x80110f00
801002cd:	e8 9e 40 00 00       	call   80104370 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 36 00 00       	call   80103960 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 0f 11 80       	push   $0x80110f20
801002f6:	e8 95 45 00 00       	call   80104890 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 0f 11 80    	mov    %edx,0x80110f00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 0e 11 80 	movsbl -0x7feef180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 0f 11 80       	push   $0x80110f20
8010034c:	e8 3f 45 00 00       	call   80104890 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 0f 11 80       	mov    %eax,0x80110f00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 0f 11 80 00 	movl   $0x0,0x80110f54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 25 00 00       	call   801028d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 86 10 80       	push   $0x8010866d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 54 8b 10 80 	movl   $0x80108b54,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 43 00 00       	call   80104720 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 86 10 80       	push   $0x80108681
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 0f 11 80 01 	movl   $0x1,0x80110f58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 cc 6c 00 00       	call   801070f0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 01 6c 00 00       	call   801070f0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 f5 6b 00 00       	call   801070f0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 e9 6b 00 00       	call   801070f0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 1a 45 00 00       	call   80104a80 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 44 00 00       	call   801049f0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 85 86 10 80       	push   $0x80108685
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801005cb:	e8 20 43 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 0f 11 80       	push   $0x80110f20
80100604:	e8 87 42 00 00       	call   80104890 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 a8 8b 10 80 	movzbl -0x7fef7458(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 0f 11 80    	mov    0x80110f54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 0f 11 80       	mov    0x80110f58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 0f 11 80       	push   $0x80110f20
801007d8:	e8 13 41 00 00       	call   801048f0 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 0f 11 80       	push   $0x80110f20
801007fb:	e8 90 40 00 00       	call   80104890 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 98 86 10 80       	mov    $0x80108698,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010084e:	66 90                	xchg   %ax,%ax
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100857:	90                   	nop
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 9f 86 10 80       	push   $0x8010869f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010089d:	8d 76 00             	lea    0x0(%esi),%esi

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 0f 11 80       	push   $0x80110f20
801008b3:	e8 38 40 00 00       	call   801048f0 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 0f 11 80       	push   $0x80110f20
801008ed:	e8 9e 3f 00 00       	call   80104890 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100914:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.e--;
80100933:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 0f 11 80       	mov    0x80110f08,%eax
8010094a:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
8010095e:	a1 58 0f 11 80       	mov    0x80110f58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 0f 11 80    	mov    %edx,0x80110f08
80100998:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 0f 11 80    	mov    %edx,0x80110f08
80100a05:	c6 80 80 0e 11 80 0a 	movb   $0xa,-0x7feef180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 0f 11 80       	mov    0x80110f08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80100a27:	68 00 0f 11 80       	push   $0x80110f00
80100a2c:	e8 ff 39 00 00       	call   80104430 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 bc 3a 00 00       	jmp    80104510 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5e:	66 90                	xchg   %ax,%ax

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 a8 86 10 80       	push   $0x801086a8
80100a6b:	68 20 0f 11 80       	push   $0x80110f20
80100a70:	e8 8b 3c 00 00       	call   80104700 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 19 11 80 b0 	movl   $0x801005b0,0x8011190c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 19 11 80 80 	movl   $0x80100280,0x80111908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 0f 11 80 01 	movl   $0x1,0x80110f54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 9f 2e 00 00       	call   80103960 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 d1 77 00 00       	call   801082f0 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 90 75 00 00       	call   80108120 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 8a 74 00 00       	call   80108050 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 68 76 00 00       	call   80108270 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 97 21 00 00       	call   80102db0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 5a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 b9 74 00 00       	call   80108120 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 08 77 00 00       	call   80108390 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ca7:	90                   	nop
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 11 3f 00 00       	call   80104be0 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 00 3f 00 00       	call   80104be0 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 6d 78 00 00       	call   80108560 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 68 75 00 00       	call   80108270 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 fc 77 00 00       	call   80108560 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 fc 3d 00 00       	call   80104ba0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 f0 70 00 00       	call   80107ec0 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 98 74 00 00       	call   80108270 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 99 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 b0 86 10 80       	push   $0x801086b0
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 bc 86 10 80       	push   $0x801086bc
80100e3b:	68 60 0f 11 80       	push   $0x80110f60
80100e40:	e8 bb 38 00 00       	call   80104700 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 0f 11 80       	mov    $0x80110f94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 0f 11 80       	push   $0x80110f60
80100e61:	e8 8a 3a 00 00       	call   801048f0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 18 11 80    	cmp    $0x801118f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 0f 11 80       	push   $0x80110f60
80100e91:	e8 fa 39 00 00       	call   80104890 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 0f 11 80       	push   $0x80110f60
80100eaa:	e8 e1 39 00 00       	call   80104890 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 0f 11 80       	push   $0x80110f60
80100ecf:	e8 1c 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 0f 11 80       	push   $0x80110f60
80100eec:	e8 9f 39 00 00       	call   80104890 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 c3 86 10 80       	push   $0x801086c3
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 0f 11 80       	push   $0x80110f60
80100f21:	e8 ca 39 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 0f 11 80       	push   $0x80110f60
80100f5c:	e8 2f 39 00 00       	call   80104890 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f80:	c7 45 08 60 0f 11 80 	movl   $0x80110f60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 fd 38 00 00       	jmp    80104890 <release>
80100f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f97:	90                   	nop
    begin_op();
80100f98:	e8 a3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 f9 1d 00 00       	jmp    80102db0 <end_op>
80100fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 32 25 00 00       	call   80103500 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 cb 86 10 80       	push   $0x801086cb
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fed:	8d 76 00             	lea    0x0(%esi),%esi

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 0e 26 00 00       	jmp    801036c0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 d5 86 10 80       	push   $0x801086d5
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 82 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ed 1b 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 26 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 de 86 10 80       	push   $0x801086de
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 d2 23 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 e4 86 10 80       	push   $0x801086e4
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 35 11 80    	mov    0x801135b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 35 11 80    	add    0x801135cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101218:	83 c4 10             	add    $0x10,%esp
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 35 11 80       	mov    0x801135b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 35 11 80    	cmp    0x801135b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 ee 86 10 80       	push   $0x801086ee
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101297:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 76 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 1e 37 00 00       	call   801049f0 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 46 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 19 11 80       	mov    $0x80111994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 19 11 80       	push   $0x80111960
8010130a:	e8 e1 35 00 00       	call   801048f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010131e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 19 11 80       	push   $0x80111960
80101377:	e8 14 35 00 00       	call   80104890 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 19 11 80       	push   $0x80111960
801013a5:	e8 e6 34 00 00       	call   80104890 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 04 87 10 80       	push   $0x80108704
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 35 11 80    	add    0x801135cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 de 1a 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 14 87 10 80       	push   $0x80108714
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146f:	90                   	nop

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 36 1a 00 00       	call   80102f20 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 27 87 10 80       	push   $0x80108727
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 1a 35 00 00       	call   80104a80 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157e:	66 90                	xchg   %ax,%ax

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 19 11 80       	mov    $0x801119a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 3a 87 10 80       	push   $0x8010873a
80101591:	68 60 19 11 80       	push   $0x80111960
80101596:	e8 65 31 00 00       	call   80104700 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 41 87 10 80       	push   $0x80108741
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 1c 30 00 00       	call   801045d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 35 11 80    	cmp    $0x801135c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 35 11 80       	push   $0x801135b4
801015dc:	e8 9f 34 00 00       	call   80104a80 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 35 11 80    	push   0x801135cc
801015ef:	ff 35 c8 35 11 80    	push   0x801135c8
801015f5:	ff 35 c4 35 11 80    	push   0x801135c4
801015fb:	ff 35 c0 35 11 80    	push   0x801135c0
80101601:	ff 35 bc 35 11 80    	push   0x801135bc
80101607:	ff 35 b8 35 11 80    	push   0x801135b8
8010160d:	ff 35 b4 35 11 80    	push   0x801135b4
80101613:	68 bc 8b 10 80       	push   $0x80108bbc
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 35 11 80 01 	cmpl   $0x1,0x801135bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 35 11 80    	cmp    0x801135bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 35 11 80    	add    0x801135c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 3d 33 00 00       	call   801049f0 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 5b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 47 87 10 80       	push   $0x80108747
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 35 11 80    	add    0x801135c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 2a 33 00 00       	call   80104a80 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 c2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 19 11 80       	push   $0x80111960
8010177f:	e8 6c 31 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010178f:	e8 fc 30 00 00       	call   80104890 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 49 2e 00 00       	call   80104610 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 35 11 80    	add    0x801135c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 43 32 00 00       	call   80104a80 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 5f 87 10 80       	push   $0x8010875f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 59 87 10 80       	push   $0x80108759
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 18 2e 00 00       	call   801046b0 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 bc 2d 00 00       	jmp    80104670 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 6e 87 10 80       	push   $0x8010876e
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 2b 2d 00 00       	call   80104610 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 71 2d 00 00       	call   80104670 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101906:	e8 e5 2f 00 00       	call   801048f0 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 19 11 80 	movl   $0x80111960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 6b 2f 00 00       	jmp    80104890 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 19 11 80       	push   $0x80111960
80101930:	e8 bb 2f 00 00       	call   801048f0 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010193f:	e8 4c 2f 00 00       	call   80104890 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019ca:	83 c4 10             	add    $0x10,%esp
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a2f:	90                   	nop

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 68 2c 00 00       	call   801046b0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 11 2c 00 00       	call   80104670 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 6e 87 10 80       	push   $0x8010876e
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 24 2f 00 00       	call   80104a80 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 19 11 80 	mov    -0x7feee700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 26 2e 00 00       	call   80104a80 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 be 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 19 11 80 	mov    -0x7feee6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 0d 2e 00 00       	call   80104af0 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 ae 2d 00 00       	call   80104af0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 88 87 10 80       	push   $0x80108788
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 76 87 10 80       	push   $0x80108776
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 a1 1b 00 00       	call   80103960 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 19 11 80       	push   $0x80111960
80101dca:	e8 21 2b 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101dda:	e8 b1 2a 00 00       	call   80104890 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 44 2c 00 00       	call   80104a80 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 0f 28 00 00       	call   801046b0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 ad 27 00 00       	call   80104670 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 90 2b 00 00       	call   80104a80 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 86 27 00 00       	call   801046b0 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 2f 27 00 00       	call   80104670 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 36 27 00 00       	call   801046b0 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 df 26 00 00       	call   80104670 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 6e 87 10 80       	push   $0x8010876e
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fbf:	90                   	nop

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 1e 2b 00 00       	call   80104b40 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 97 87 10 80       	push   $0x80108797
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 f3 89 10 80       	push   $0x801089f3
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ee:	66 90                	xchg   %ax,%ax
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 ad 87 10 80       	push   $0x801087ad
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 a4 87 10 80       	push   $0x801087a4
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 bf 87 10 80       	push   $0x801087bf
801021ab:	68 00 36 11 80       	push   $0x80113600
801021b0:	e8 4b 25 00 00       	call   80104700 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 37 11 80       	mov    0x80113784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 35 11 80 01 	movl   $0x1,0x801135e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 36 11 80       	push   $0x80113600
8010223e:	e8 ad 26 00 00       	call   801048f0 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 35 11 80    	mov    0x801135e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 35 11 80       	mov    %eax,0x801135e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010226e:	66 90                	xchg   %ax,%ax
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 8e 21 00 00       	call   80104430 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 35 11 80       	mov    0x801135e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 36 11 80       	push   $0x80113600
801022bb:	e8 d0 25 00 00       	call   80104890 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 cd 23 00 00       	call   801046b0 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 35 11 80       	mov    0x801135e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 36 11 80       	push   $0x80113600
80102318:	e8 d3 25 00 00       	call   801048f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 35 11 80       	mov    0x801135e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 35 11 80    	cmp    %ebx,0x801135e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 36 11 80       	push   $0x80113600
80102358:	53                   	push   %ebx
80102359:	e8 12 20 00 00       	call   80104370 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 36 11 80 	movl   $0x80113600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 15 25 00 00       	jmp    80104890 <release>
8010237b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010237f:	90                   	nop
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 35 11 80       	mov    $0x801135e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 ee 87 10 80       	push   $0x801087ee
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 d9 87 10 80       	push   $0x801087d9
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 c3 87 10 80       	push   $0x801087c3
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 10 8c 10 80       	push   $0x80108c10
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024b0:	75 76                	jne    80102528 <kfree+0x88>
801024b2:	81 fb d0 14 15 80    	cmp    $0x801514d0,%ebx
801024b8:	72 6e                	jb     80102528 <kfree+0x88>
801024ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024c5:	77 61                	ja     80102528 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	68 00 10 00 00       	push   $0x1000
801024cf:	6a 01                	push   $0x1
801024d1:	53                   	push   %ebx
801024d2:	e8 19 25 00 00       	call   801049f0 <memset>

  if(kmem.use_lock)
801024d7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	85 d2                	test   %edx,%edx
801024e2:	75 1c                	jne    80102500 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e4:	a1 78 36 11 80       	mov    0x80113678,%eax
801024e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024eb:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024f0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024f6:	85 c0                	test   %eax,%eax
801024f8:	75 1e                	jne    80102518 <kfree+0x78>
    release(&kmem.lock);
}
801024fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fd:	c9                   	leave
801024fe:	c3                   	ret
801024ff:	90                   	nop
    acquire(&kmem.lock);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 40 36 11 80       	push   $0x80113640
80102508:	e8 e3 23 00 00       	call   801048f0 <acquire>
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	eb d2                	jmp    801024e4 <kfree+0x44>
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102518:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102522:	c9                   	leave
    release(&kmem.lock);
80102523:	e9 68 23 00 00       	jmp    80104890 <release>
    panic("kfree");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 0c 88 10 80       	push   $0x8010880c
80102530:	e8 4b de ff ff       	call   80100380 <panic>
80102535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <freerange+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 23 ff ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret
8010258b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop

80102590 <kinit2>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <kinit2+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 d3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit2+0x28>
  kmem.use_lock = 1;
801025d4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801025db:	00 00 00 
}
801025de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret
801025e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025f0 <kinit1>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	68 12 88 10 80       	push   $0x80108812
80102600:	68 40 36 11 80       	push   $0x80113640
80102605:	e8 f6 20 00 00       	call   80104700 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102610:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102617:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262c:	39 de                	cmp    %ebx,%esi
8010262e:	72 1c                	jb     8010264c <kinit1+0x5c>
    kfree(p);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263f:	50                   	push   %eax
80102640:	e8 5b fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 de                	cmp    %ebx,%esi
8010264a:	73 e4                	jae    80102630 <kinit1+0x40>
}
8010264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010264f:	5b                   	pop    %ebx
80102650:	5e                   	pop    %esi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret
80102653:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102667:	a1 74 36 11 80       	mov    0x80113674,%eax
8010266c:	85 c0                	test   %eax,%eax
8010266e:	75 20                	jne    80102690 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102670:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102676:	85 db                	test   %ebx,%ebx
80102678:	74 07                	je     80102681 <kalloc+0x21>
    kmem.freelist = r->next;
8010267a:	8b 03                	mov    (%ebx),%eax
8010267c:	a3 78 36 11 80       	mov    %eax,0x80113678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102681:	89 d8                	mov    %ebx,%eax
80102683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102686:	c9                   	leave
80102687:	c3                   	ret
80102688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 36 11 80       	push   $0x80113640
80102698:	e8 53 22 00 00       	call   801048f0 <acquire>
  r = kmem.freelist;
8010269d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(kmem.use_lock)
801026a3:	a1 74 36 11 80       	mov    0x80113674,%eax
  if(r)
801026a8:	83 c4 10             	add    $0x10,%esp
801026ab:	85 db                	test   %ebx,%ebx
801026ad:	74 08                	je     801026b7 <kalloc+0x57>
    kmem.freelist = r->next;
801026af:	8b 13                	mov    (%ebx),%edx
801026b1:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801026b7:	85 c0                	test   %eax,%eax
801026b9:	74 c6                	je     80102681 <kalloc+0x21>
    release(&kmem.lock);
801026bb:	83 ec 0c             	sub    $0xc,%esp
801026be:	68 40 36 11 80       	push   $0x80113640
801026c3:	e8 c8 21 00 00       	call   80104890 <release>
}
801026c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026ca:	83 c4 10             	add    $0x10,%esp
}
801026cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d0:	c9                   	leave
801026d1:	c3                   	ret
801026d2:	66 90                	xchg   %ax,%ax
801026d4:	66 90                	xchg   %ax,%ax
801026d6:	66 90                	xchg   %ax,%ax
801026d8:	66 90                	xchg   %ax,%ax
801026da:	66 90                	xchg   %ax,%ax
801026dc:	66 90                	xchg   %ax,%ax
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e0:	ba 64 00 00 00       	mov    $0x64,%edx
801026e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026e6:	a8 01                	test   $0x1,%al
801026e8:	0f 84 c2 00 00 00    	je     801027b0 <kbdgetc+0xd0>
{
801026ee:	55                   	push   %ebp
801026ef:	ba 60 00 00 00       	mov    $0x60,%edx
801026f4:	89 e5                	mov    %esp,%ebp
801026f6:	53                   	push   %ebx
801026f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026f8:	8b 1d 7c 36 11 80    	mov    0x8011367c,%ebx
  data = inb(KBDATAP);
801026fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102701:	3c e0                	cmp    $0xe0,%al
80102703:	74 5b                	je     80102760 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102705:	89 da                	mov    %ebx,%edx
80102707:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010270a:	84 c0                	test   %al,%al
8010270c:	78 62                	js     80102770 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010270e:	85 d2                	test   %edx,%edx
80102710:	74 09                	je     8010271b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102712:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102715:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102718:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010271b:	0f b6 91 e0 8e 10 80 	movzbl -0x7fef7120(%ecx),%edx
  shift ^= togglecode[data];
80102722:	0f b6 81 e0 8d 10 80 	movzbl -0x7fef7220(%ecx),%eax
  shift |= shiftcode[data];
80102729:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010272b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010272f:	89 15 7c 36 11 80    	mov    %edx,0x8011367c
  c = charcode[shift & (CTL | SHIFT)][data];
80102735:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102738:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273b:	8b 04 85 c0 8d 10 80 	mov    -0x7fef7240(,%eax,4),%eax
80102742:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102746:	74 0b                	je     80102753 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102748:	8d 50 9f             	lea    -0x61(%eax),%edx
8010274b:	83 fa 19             	cmp    $0x19,%edx
8010274e:	77 48                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102750:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave
80102757:	c3                   	ret
80102758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275f:	90                   	nop
    shift |= E0ESC;
80102760:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102763:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102765:	89 1d 7c 36 11 80    	mov    %ebx,0x8011367c
}
8010276b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276e:	c9                   	leave
8010276f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 d2                	test   %edx,%edx
80102775:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102778:	0f b6 81 e0 8e 10 80 	movzbl -0x7fef7120(%ecx),%eax
8010277f:	83 c8 40             	or     $0x40,%eax
80102782:	0f b6 c0             	movzbl %al,%eax
80102785:	f7 d0                	not    %eax
80102787:	21 d8                	and    %ebx,%eax
80102789:	a3 7c 36 11 80       	mov    %eax,0x8011367c
    return 0;
8010278e:	31 c0                	xor    %eax,%eax
80102790:	eb d9                	jmp    8010276b <kbdgetc+0x8b>
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a1:	c9                   	leave
      c += 'a' - 'A';
801027a2:	83 f9 1a             	cmp    $0x1a,%ecx
801027a5:	0f 42 c2             	cmovb  %edx,%eax
}
801027a8:	c3                   	ret
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret
801027b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027c6:	68 e0 26 10 80       	push   $0x801026e0
801027cb:	e8 d0 e0 ff ff       	call   801008a0 <consoleintr>
}
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	c9                   	leave
801027d4:	c3                   	ret
801027d5:	66 90                	xchg   %ax,%ax
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 80 36 11 80       	mov    0x80113680,%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	0f 84 c3 00 00 00    	je     801028b0 <lapicinit+0xd0>
  lapic[index] = value;
801027ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102801:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010280e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102835:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102838:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283b:	8b 50 30             	mov    0x30(%eax),%edx
8010283e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102844:	75 72                	jne    801028b8 <lapicinit+0xd8>
  lapic[index] = value;
80102846:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010288e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102898:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010289e:	80 e6 10             	and    $0x10,%dh
801028a1:	75 f5                	jne    80102898 <lapicinit+0xb8>
  lapic[index] = value;
801028a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b0:	c3                   	ret
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028c5:	e9 7c ff ff ff       	jmp    80102846 <lapicinit+0x66>
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	a1 80 36 11 80       	mov    0x80113680,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	74 07                	je     801028e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028d9:	8b 40 20             	mov    0x20(%eax),%eax
801028dc:	c1 e8 18             	shr    $0x18,%eax
801028df:	c3                   	ret
    return 0;
801028e0:	31 c0                	xor    %eax,%eax
}
801028e2:	c3                   	ret
801028e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 80 36 11 80       	mov    0x80113680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 0d                	je     80102906 <lapiceoi+0x16>
  lapic[index] = value;
801028f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102906:	c3                   	ret
80102907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290e:	66 90                	xchg   %ax,%ax

80102910 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102910:	c3                   	ret
80102911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102950:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102952:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 80 36 11 80       	mov    0x80113680,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ad:	c9                   	leave
801029ae:	c3                   	ret
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bf 70 00 00 00       	mov    $0x70,%edi
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 fa                	mov    %edi,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 fa                	mov    %edi,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 fa                	mov    %edi,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 fa                	mov    %edi,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 fa                	mov    %edi,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2d:	89 fa                	mov    %edi,%edx
80102a2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a35:	89 ca                	mov    %ecx,%edx
80102a37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a38:	84 c0                	test   %al,%al
80102a3a:	78 9c                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a40:	89 f2                	mov    %esi,%edx
80102a42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 fa                	mov    %edi,%edx
80102a4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a65:	31 c0                	xor    %eax,%eax
80102a67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a68:	89 ca                	mov    %ecx,%edx
80102a6a:	ec                   	in     (%dx),%al
80102a6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6e:	89 fa                	mov    %edi,%edx
80102a70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a73:	b8 02 00 00 00       	mov    $0x2,%eax
80102a78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a79:	89 ca                	mov    %ecx,%edx
80102a7b:	ec                   	in     (%dx),%al
80102a7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a84:	b8 04 00 00 00       	mov    $0x4,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 fa                	mov    %edi,%edx
80102a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a95:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9b:	89 ca                	mov    %ecx,%edx
80102a9d:	ec                   	in     (%dx),%al
80102a9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	89 fa                	mov    %edi,%edx
80102aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa6:	b8 08 00 00 00       	mov    $0x8,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 fa                	mov    %edi,%edx
80102ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab7:	b8 09 00 00 00       	mov    $0x9,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102acc:	6a 18                	push   $0x18
80102ace:	50                   	push   %eax
80102acf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad2:	50                   	push   %eax
80102ad3:	e8 58 1f 00 00       	call   80104a30 <memcmp>
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c0                	test   %eax,%eax
80102add:	0f 85 f5 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aea:	89 f0                	mov    %esi,%eax
80102aec:	84 c0                	test   %al,%al
80102aee:	75 78                	jne    80102b68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af3:	89 c2                	mov    %eax,%edx
80102af5:	83 e0 0f             	and    $0xf,%eax
80102af8:	c1 ea 04             	shr    $0x4,%edx
80102afb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b07:	89 c2                	mov    %eax,%edx
80102b09:	83 e0 0f             	and    $0xf,%eax
80102b0c:	c1 ea 04             	shr    $0x4,%edx
80102b0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b1b:	89 c2                	mov    %eax,%edx
80102b1d:	83 e0 0f             	and    $0xf,%eax
80102b20:	c1 ea 04             	shr    $0x4,%edx
80102b23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2f:	89 c2                	mov    %eax,%edx
80102b31:	83 e0 0f             	and    $0xf,%eax
80102b34:	c1 ea 04             	shr    $0x4,%edx
80102b37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 03                	mov    %eax,(%ebx)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 43 04             	mov    %eax,0x4(%ebx)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 43 08             	mov    %eax,0x8(%ebx)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 43 10             	mov    %eax,0x10(%ebx)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102b8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 e4 36 11 80    	push   0x801136e4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd ec 36 11 80 	push   -0x7feec914(,%edi,4)
80102be4:	ff 35 e4 36 11 80    	push   0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 77 1e 00 00       	call   80104a80 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 d4 36 11 80    	push   0x801136d4
80102c4d:	ff 35 e4 36 11 80    	push   0x801136e4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave
80102c9a:	c3                   	ret
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 17 88 10 80       	push   $0x80108817
80102caf:	68 a0 36 11 80       	push   $0x801136a0
80102cb4:	e8 47 1a 00 00       	call   80104700 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 7b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cc8:	59                   	pop    %ecx
  log.dev = dev;
80102cc9:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd2:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102cd7:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ce8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ceb:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	85 db                	test   %ebx,%ebx
80102cf3:	7e 1d                	jle    80102d12 <initlog+0x72>
80102cf5:	31 d2                	xor    %edx,%edx
80102cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cfe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d04:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d3                	cmp    %edx,%ebx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave
80102d36:	c3                   	ret
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 a0 36 11 80       	push   $0x801136a0
80102d4b:	e8 a0 1b 00 00       	call   801048f0 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 a0 36 11 80       	push   $0x801136a0
80102d60:	68 a0 36 11 80       	push   $0x801136a0
80102d65:	e8 06 16 00 00       	call   80104370 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d7b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102d97:	68 a0 36 11 80       	push   $0x801136a0
80102d9c:	e8 ef 1a 00 00       	call   80104890 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave
80102da5:	c3                   	ret
80102da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dad:	8d 76 00             	lea    0x0(%esi),%esi

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 a0 36 11 80       	push   $0x801136a0
80102dbe:	e8 2d 1b 00 00       	call   801048f0 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102dc8:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dea:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102df1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 a0 36 11 80       	push   $0x801136a0
80102dfc:	e8 8f 1a 00 00       	call   80104890 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 a0 36 11 80       	push   $0x801136a0
80102e16:	e8 d5 1a 00 00       	call   801048f0 <acquire>
    log.committing = 0;
80102e1b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e22:	00 00 00 
    wakeup(&log);
80102e25:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e2c:	e8 ff 15 00 00       	call   80104430 <wakeup>
    release(&log.lock);
80102e31:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e38:	e8 53 1a 00 00       	call   80104890 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret
80102e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 e4 36 11 80    	push   0x801136e4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d ec 36 11 80 	push   -0x7feec914(,%ebx,4)
80102e74:	ff 35 e4 36 11 80    	push   0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 e7 1b 00 00       	call   80104a80 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 a0 36 11 80       	push   $0x801136a0
80102ee8:	e8 43 15 00 00       	call   80104430 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102ef4:	e8 97 19 00 00       	call   80104890 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 1b 88 10 80       	push   $0x8010881b
80102f0c:	e8 6f d4 ff ff       	call   80100380 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	7f 7d                	jg     80102fb2 <log_write+0x92>
80102f35:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f3a:	83 e8 01             	sub    $0x1,%eax
80102f3d:	39 c2                	cmp    %eax,%edx
80102f3f:	7d 71                	jge    80102fb2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f41:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	7e 75                	jle    80102fbf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 36 11 80       	push   $0x801136a0
80102f52:	e8 99 19 00 00       	call   801048f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f57:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	31 c0                	xor    %eax,%eax
80102f5f:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102f65:	85 d2                	test   %edx,%edx
80102f67:	7f 0e                	jg     80102f77 <log_write+0x57>
80102f69:	eb 15                	jmp    80102f80 <log_write+0x60>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
80102f87:	39 c2                	cmp    %eax,%edx
80102f89:	74 1c                	je     80102fa7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f8b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f91:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102f98:	c9                   	leave
  release(&log.lock);
80102f99:	e9 f2 18 00 00       	jmp    80104890 <release>
80102f9e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fb0:	eb d9                	jmp    80102f8b <log_write+0x6b>
    panic("too big a transaction");
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	68 2a 88 10 80       	push   $0x8010882a
80102fba:	e8 c1 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fbf:	83 ec 0c             	sub    $0xc,%esp
80102fc2:	68 40 88 10 80       	push   $0x80108840
80102fc7:	e8 b4 d3 ff ff       	call   80100380 <panic>
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 64 09 00 00       	call   80103940 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 5d 09 00 00       	call   80103940 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 5b 88 10 80       	push   $0x8010885b
80102fed:	e8 be d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 79 3a 00 00       	call   80106a70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 e4 08 00 00       	call   801038e0 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 01 0f 00 00       	call   80103f10 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 95 4e 00 00       	call   80107eb0 <switchkvm>
  seginit();
8010301b:	e8 80 4c 00 00       	call   80107ca0 <seginit>
  lapicinit();
80103020:	e8 bb f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 d0 14 15 80       	push   $0x801514d0
8010304c:	e8 9f f5 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 1a 53 00 00       	call   80108370 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 80 f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 3b 4c 00 00       	call   80107ca0 <seginit>
  picinit();       // disable pic
80103065:	e8 86 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 51 f3 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 ec d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103074:	e8 87 3f 00 00       	call   80107000 <uartinit>
  pinit();         // process table
80103079:	e8 42 08 00 00       	call   801038c0 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 6d 39 00 00       	call   801069f0 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 a3 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010308d:	e8 0e f1 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c c4 10 80       	push   $0x8010c48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 d7 19 00 00       	call   80104a80 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030bb:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 f2 07 00 00       	call   801038e0 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 69 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010310b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 fa f7 ff ff       	call   80102920 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 3e f4 ff ff       	call   80102590 <kinit2>
  userinit();      // first user process
80103152:	e8 39 08 00 00       	call   80103990 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 df                	cmp    %ebx,%edi
80103184:	73 42                	jae    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 6f 88 10 80       	push   $0x8010886f
80103193:	56                   	push   %esi
80103194:	e8 97 18 00 00       	call   80104a30 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret
801031d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c3                	mov    %eax,%ebx
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 58 01 00 00    	je     80103388 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 73 04             	mov    0x4(%ebx),%esi
80103233:	85 f6                	test   %esi,%esi
80103235:	0f 84 3d 01 00 00    	je     80103378 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	6a 04                	push   $0x4
80103249:	68 74 88 10 80       	push   $0x80108874
8010324e:	50                   	push   %eax
8010324f:	e8 dc 17 00 00       	call   80104a30 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 19 01 00 00    	jne    80103378 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	74 08                	je     80103272 <mpinit+0x92>
8010326a:	3c 04                	cmp    $0x4,%al
8010326c:	0f 85 06 01 00 00    	jne    80103378 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103272:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103279:	66 85 d2             	test   %dx,%dx
8010327c:	74 22                	je     801032a0 <mpinit+0xc0>
8010327e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103281:	89 f0                	mov    %esi,%eax
  sum = 0;
80103283:	31 d2                	xor    %edx,%edx
80103285:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010328f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103292:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103294:	39 f8                	cmp    %edi,%eax
80103296:	75 f0                	jne    80103288 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103298:	84 d2                	test   %dl,%dl
8010329a:	0f 85 d8 00 00 00    	jne    80103378 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032ac:	a3 80 36 11 80       	mov    %eax,0x80113680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032b8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032be:	01 d7                	add    %edx,%edi
801032c0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801032c2:	bf 01 00 00 00       	mov    $0x1,%edi
801032c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032ce:	66 90                	xchg   %ax,%ax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d0:	39 d0                	cmp    %edx,%eax
801032d2:	73 19                	jae    801032ed <mpinit+0x10d>
    switch(*p){
801032d4:	0f b6 08             	movzbl (%eax),%ecx
801032d7:	80 f9 02             	cmp    $0x2,%cl
801032da:	0f 84 80 00 00 00    	je     80103360 <mpinit+0x180>
801032e0:	77 6e                	ja     80103350 <mpinit+0x170>
801032e2:	84 c9                	test   %cl,%cl
801032e4:	74 3a                	je     80103320 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e9:	39 d0                	cmp    %edx,%eax
801032eb:	72 e7                	jb     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032f0:	85 ff                	test   %edi,%edi
801032f2:	0f 84 dd 00 00 00    	je     801033d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032fc:	74 15                	je     80103313 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103303:	ba 22 00 00 00       	mov    $0x22,%edx
80103308:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	ba 23 00 00 00       	mov    $0x23,%edx
8010330e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010330f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103312:	ee                   	out    %al,(%dx)
  }
}
80103313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5f                   	pop    %edi
80103319:	5d                   	pop    %ebp
8010331a:	c3                   	ret
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop
      if(ncpu < NCPU) {
80103320:	8b 0d 84 37 11 80    	mov    0x80113784,%ecx
80103326:	83 f9 07             	cmp    $0x7,%ecx
80103329:	7f 19                	jg     80103344 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010332b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103331:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103335:	83 c1 01             	add    $0x1,%ecx
80103338:	89 0d 84 37 11 80    	mov    %ecx,0x80113784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010333e:	88 9e a0 37 11 80    	mov    %bl,-0x7feec860(%esi)
      p += sizeof(struct mpproc);
80103344:	83 c0 14             	add    $0x14,%eax
      continue;
80103347:	eb 87                	jmp    801032d0 <mpinit+0xf0>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 8e                	jbe    801032e6 <mpinit+0x106>
80103358:	31 ff                	xor    %edi,%edi
8010335a:	e9 71 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010335f:	90                   	nop
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
8010336d:	e9 5e ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	68 79 88 10 80       	push   $0x80108879
80103380:	e8 fb cf ff ff       	call   80100380 <panic>
80103385:	8d 76 00             	lea    0x0(%esi),%esi
{
80103388:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010338d:	eb 0b                	jmp    8010339a <mpinit+0x1ba>
8010338f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103390:	89 f3                	mov    %esi,%ebx
80103392:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103398:	74 de                	je     80103378 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010339a:	83 ec 04             	sub    $0x4,%esp
8010339d:	8d 73 10             	lea    0x10(%ebx),%esi
801033a0:	6a 04                	push   $0x4
801033a2:	68 6f 88 10 80       	push   $0x8010886f
801033a7:	53                   	push   %ebx
801033a8:	e8 83 16 00 00       	call   80104a30 <memcmp>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	85 c0                	test   %eax,%eax
801033b2:	75 dc                	jne    80103390 <mpinit+0x1b0>
801033b4:	89 da                	mov    %ebx,%edx
801033b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033c8:	39 d6                	cmp    %edx,%esi
801033ca:	75 f4                	jne    801033c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033cc:	84 c0                	test   %al,%al
801033ce:	75 c0                	jne    80103390 <mpinit+0x1b0>
801033d0:	e9 5b fe ff ff       	jmp    80103230 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033d5:	83 ec 0c             	sub    $0xc,%esp
801033d8:	68 44 8c 10 80       	push   $0x80108c44
801033dd:	e8 9e cf ff ff       	call   80100380 <panic>
801033e2:	66 90                	xchg   %ax,%ax
801033e4:	66 90                	xchg   %ax,%ax
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <picinit>:
801033f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f5:	ba 21 00 00 00       	mov    $0x21,%edx
801033fa:	ee                   	out    %al,(%dx)
801033fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103400:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103401:	c3                   	ret
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010341f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103425:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342b:	e8 20 da ff ff       	call   80100e50 <filealloc>
80103430:	89 06                	mov    %eax,(%esi)
80103432:	85 c0                	test   %eax,%eax
80103434:	0f 84 a5 00 00 00    	je     801034df <pipealloc+0xcf>
8010343a:	e8 11 da ff ff       	call   80100e50 <filealloc>
8010343f:	89 07                	mov    %eax,(%edi)
80103441:	85 c0                	test   %eax,%eax
80103443:	0f 84 84 00 00 00    	je     801034cd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103449:	e8 12 f2 ff ff       	call   80102660 <kalloc>
8010344e:	89 c3                	mov    %eax,%ebx
80103450:	85 c0                	test   %eax,%eax
80103452:	0f 84 a0 00 00 00    	je     801034f8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103458:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010345f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103462:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103465:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010346c:	00 00 00 
  p->nwrite = 0;
8010346f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103476:	00 00 00 
  p->nread = 0;
80103479:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103480:	00 00 00 
  initlock(&p->lock, "pipe");
80103483:	68 91 88 10 80       	push   $0x80108891
80103488:	50                   	push   %eax
80103489:	e8 72 12 00 00       	call   80104700 <initlock>
  (*f0)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103490:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103493:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103499:	8b 06                	mov    (%esi),%eax
8010349b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010349f:	8b 06                	mov    (%esi),%eax
801034a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034a5:	8b 06                	mov    (%esi),%eax
801034a7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034aa:	8b 07                	mov    (%edi),%eax
801034ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034b2:	8b 07                	mov    (%edi),%eax
801034b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034b8:	8b 07                	mov    (%edi),%eax
801034ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034be:	8b 07                	mov    (%edi),%eax
801034c0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034c3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c8:	5b                   	pop    %ebx
801034c9:	5e                   	pop    %esi
801034ca:	5f                   	pop    %edi
801034cb:	5d                   	pop    %ebp
801034cc:	c3                   	ret
  if(*f0)
801034cd:	8b 06                	mov    (%esi),%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 1e                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f0);
801034d3:	83 ec 0c             	sub    $0xc,%esp
801034d6:	50                   	push   %eax
801034d7:	e8 34 da ff ff       	call   80100f10 <fileclose>
801034dc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034df:	8b 07                	mov    (%edi),%eax
801034e1:	85 c0                	test   %eax,%eax
801034e3:	74 0c                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f1);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	50                   	push   %eax
801034e9:	e8 22 da ff ff       	call   80100f10 <fileclose>
801034ee:	83 c4 10             	add    $0x10,%esp
  return -1;
801034f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034f6:	eb cd                	jmp    801034c5 <pipealloc+0xb5>
  if(*f0)
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 d5                	jne    801034d3 <pipealloc+0xc3>
801034fe:	eb df                	jmp    801034df <pipealloc+0xcf>

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 dc 13 00 00       	call   801048f0 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 65                	je     80103580 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 fc 0e 00 00       	call   80104430 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 15                	je     80103560 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 37 13 00 00       	jmp    80104890 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 27 13 00 00       	call   80104890 <release>
    kfree((char*)p);
80103569:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010356c:	83 c4 10             	add    $0x10,%esp
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    kfree((char*)p);
80103575:	e9 26 ef ff ff       	jmp    801024a0 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 97 0e 00 00       	call   80104430 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb 99                	jmp    80103537 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035af:	53                   	push   %ebx
801035b0:	e8 3b 13 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++){
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 ff                	test   %edi,%edi
801035ba:	0f 8e ce 00 00 00    	jle    8010368e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035c9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035cf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801035d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035d5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035db:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035ed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801035f0:	0f 85 b6 00 00 00    	jne    801036ac <pipewrite+0x10c>
801035f6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035f9:	eb 3b                	jmp    80103636 <pipewrite+0x96>
801035fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035ff:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103600:	e8 5b 03 00 00       	call   80103960 <myproc>
80103605:	8b 48 24             	mov    0x24(%eax),%ecx
80103608:	85 c9                	test   %ecx,%ecx
8010360a:	75 34                	jne    80103640 <pipewrite+0xa0>
      wakeup(&p->nread);
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	56                   	push   %esi
80103610:	e8 1b 0e 00 00       	call   80104430 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103615:	58                   	pop    %eax
80103616:	5a                   	pop    %edx
80103617:	53                   	push   %ebx
80103618:	57                   	push   %edi
80103619:	e8 52 0d 00 00       	call   80104370 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103624:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010362a:	83 c4 10             	add    $0x10,%esp
8010362d:	05 00 02 00 00       	add    $0x200,%eax
80103632:	39 c2                	cmp    %eax,%edx
80103634:	75 2a                	jne    80103660 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103636:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010363c:	85 c0                	test   %eax,%eax
8010363e:	75 c0                	jne    80103600 <pipewrite+0x60>
        release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 47 12 00 00       	call   80104890 <release>
        return -1;
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103654:	5b                   	pop    %ebx
80103655:	5e                   	pop    %esi
80103656:	5f                   	pop    %edi
80103657:	5d                   	pop    %ebp
80103658:	c3                   	ret
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103660:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103663:	8d 42 01             	lea    0x1(%edx),%eax
80103666:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010366c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103678:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010367c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103683:	39 c1                	cmp    %eax,%ecx
80103685:	0f 85 50 ff ff ff    	jne    801035db <pipewrite+0x3b>
8010368b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103697:	50                   	push   %eax
80103698:	e8 93 0d 00 00       	call   80104430 <wakeup>
  release(&p->lock);
8010369d:	89 1c 24             	mov    %ebx,(%esp)
801036a0:	e8 eb 11 00 00       	call   80104890 <release>
  return n;
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	89 f8                	mov    %edi,%eax
801036aa:	eb a5                	jmp    80103651 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036af:	eb b2                	jmp    80103663 <pipewrite+0xc3>
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036bf:	90                   	nop

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 18             	sub    $0x18,%esp
801036c9:	8b 75 08             	mov    0x8(%ebp),%esi
801036cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	56                   	push   %esi
801036d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036d6:	e8 15 12 00 00       	call   801048f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036ea:	74 2f                	je     8010371b <piperead+0x5b>
801036ec:	eb 37                	jmp    80103725 <piperead+0x65>
801036ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801036f0:	e8 6b 02 00 00       	call   80103960 <myproc>
801036f5:	8b 40 24             	mov    0x24(%eax),%eax
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 85 80 00 00 00    	jne    80103780 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	e8 66 0c 00 00       	call   80104370 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103710:	83 c4 10             	add    $0x10,%esp
80103713:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103719:	75 0a                	jne    80103725 <piperead+0x65>
8010371b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103721:	85 d2                	test   %edx,%edx
80103723:	75 cb                	jne    801036f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103725:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103728:	31 db                	xor    %ebx,%ebx
8010372a:	85 c9                	test   %ecx,%ecx
8010372c:	7f 26                	jg     80103754 <piperead+0x94>
8010372e:	eb 2c                	jmp    8010375c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0x9c>
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 c5 0c 00 00       	call   80104430 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 1d 11 00 00       	call   80104890 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 02 11 00 00       	call   80104890 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 3d 11 80       	push   $0x80113d20
801037b1:	e8 3a 11 00 00       	call   801048f0 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 13                	jmp    801037ce <allocproc+0x2e>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 fc 0e 00 00    	add    $0xefc,%ebx
801037c6:	81 fb 54 fc 14 80    	cmp    $0x8014fc54,%ebx
801037cc:	74 7a                	je     80103848 <allocproc+0xa8>
    if(p->state == UNUSED)
801037ce:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d1:	85 c0                	test   %eax,%eax
801037d3:	75 eb                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d5:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
801037da:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037dd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037e4:	89 43 10             	mov    %eax,0x10(%ebx)
801037e7:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037ea:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801037ef:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
801037f5:	e8 96 10 00 00       	call   80104890 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037fa:	e8 61 ee ff ff       	call   80102660 <kalloc>
801037ff:	83 c4 10             	add    $0x10,%esp
80103802:	89 43 08             	mov    %eax,0x8(%ebx)
80103805:	85 c0                	test   %eax,%eax
80103807:	74 58                	je     80103861 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103809:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010380f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103812:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103817:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010381a:	c7 40 14 db 69 10 80 	movl   $0x801069db,0x14(%eax)
  p->context = (struct context*)sp;
80103821:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103824:	6a 14                	push   $0x14
80103826:	6a 00                	push   $0x0
80103828:	50                   	push   %eax
80103829:	e8 c2 11 00 00       	call   801049f0 <memset>
  p->context->eip = (uint)forkret;
8010382e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103831:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103834:	c7 40 10 70 38 10 80 	movl   $0x80103870,0x10(%eax)
}
8010383b:	89 d8                	mov    %ebx,%eax
8010383d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103840:	c9                   	leave
80103841:	c3                   	ret
80103842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103848:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010384b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010384d:	68 20 3d 11 80       	push   $0x80113d20
80103852:	e8 39 10 00 00       	call   80104890 <release>
  return 0;
80103857:	83 c4 10             	add    $0x10,%esp
}
8010385a:	89 d8                	mov    %ebx,%eax
8010385c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385f:	c9                   	leave
80103860:	c3                   	ret
    p->state = UNUSED;
80103861:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103868:	31 db                	xor    %ebx,%ebx
8010386a:	eb ee                	jmp    8010385a <allocproc+0xba>
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103876:	68 20 3d 11 80       	push   $0x80113d20
8010387b:	e8 10 10 00 00       	call   80104890 <release>

  if (first) {
80103880:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	85 c0                	test   %eax,%eax
8010388a:	75 04                	jne    80103890 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010388c:	c9                   	leave
8010388d:	c3                   	ret
8010388e:	66 90                	xchg   %ax,%ax
    first = 0;
80103890:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103897:	00 00 00 
    iinit(ROOTDEV);
8010389a:	83 ec 0c             	sub    $0xc,%esp
8010389d:	6a 01                	push   $0x1
8010389f:	e8 dc dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038ab:	e8 f0 f3 ff ff       	call   80102ca0 <initlog>
}
801038b0:	83 c4 10             	add    $0x10,%esp
801038b3:	c9                   	leave
801038b4:	c3                   	ret
801038b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038c0 <pinit>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038c6:	68 96 88 10 80       	push   $0x80108896
801038cb:	68 20 3d 11 80       	push   $0x80113d20
801038d0:	e8 2b 0e 00 00       	call   80104700 <initlock>
}
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	c9                   	leave
801038d9:	c3                   	ret
801038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038e0 <mycpu>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038e5:	9c                   	pushf
801038e6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038e7:	f6 c4 02             	test   $0x2,%ah
801038ea:	75 46                	jne    80103932 <mycpu+0x52>
  apicid = lapicid();
801038ec:	e8 df ef ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038f1:	8b 35 84 37 11 80    	mov    0x80113784,%esi
801038f7:	85 f6                	test   %esi,%esi
801038f9:	7e 2a                	jle    80103925 <mycpu+0x45>
801038fb:	31 d2                	xor    %edx,%edx
801038fd:	eb 08                	jmp    80103907 <mycpu+0x27>
801038ff:	90                   	nop
80103900:	83 c2 01             	add    $0x1,%edx
80103903:	39 f2                	cmp    %esi,%edx
80103905:	74 1e                	je     80103925 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103907:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010390d:	0f b6 99 a0 37 11 80 	movzbl -0x7feec860(%ecx),%ebx
80103914:	39 c3                	cmp    %eax,%ebx
80103916:	75 e8                	jne    80103900 <mycpu+0x20>
}
80103918:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010391b:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5d                   	pop    %ebp
80103924:	c3                   	ret
  panic("unknown apicid\n");
80103925:	83 ec 0c             	sub    $0xc,%esp
80103928:	68 9d 88 10 80       	push   $0x8010889d
8010392d:	e8 4e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103932:	83 ec 0c             	sub    $0xc,%esp
80103935:	68 64 8c 10 80       	push   $0x80108c64
8010393a:	e8 41 ca ff ff       	call   80100380 <panic>
8010393f:	90                   	nop

80103940 <cpuid>:
cpuid() {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103946:	e8 95 ff ff ff       	call   801038e0 <mycpu>
}
8010394b:	c9                   	leave
  return mycpu()-cpus;
8010394c:	2d a0 37 11 80       	sub    $0x801137a0,%eax
80103951:	c1 f8 04             	sar    $0x4,%eax
80103954:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010395a:	c3                   	ret
8010395b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop

80103960 <myproc>:
myproc(void) {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103967:	e8 34 0e 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010396c:	e8 6f ff ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103971:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103977:	e8 74 0e 00 00       	call   801047f0 <popcli>
}
8010397c:	89 d8                	mov    %ebx,%eax
8010397e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103981:	c9                   	leave
80103982:	c3                   	ret
80103983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103990 <userinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103997:	e8 04 fe ff ff       	call   801037a0 <allocproc>
8010399c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010399e:	a3 54 fc 14 80       	mov    %eax,0x8014fc54
  if((p->pgdir = setupkvm()) == 0)
801039a3:	e8 48 49 00 00       	call   801082f0 <setupkvm>
801039a8:	89 43 04             	mov    %eax,0x4(%ebx)
801039ab:	85 c0                	test   %eax,%eax
801039ad:	0f 84 06 01 00 00    	je     80103ab9 <userinit+0x129>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039b3:	83 ec 04             	sub    $0x4,%esp
801039b6:	68 2c 00 00 00       	push   $0x2c
801039bb:	68 60 c4 10 80       	push   $0x8010c460
801039c0:	50                   	push   %eax
801039c1:	e8 0a 46 00 00       	call   80107fd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039cf:	6a 4c                	push   $0x4c
801039d1:	6a 00                	push   $0x0
801039d3:	ff 73 18             	push   0x18(%ebx)
801039d6:	e8 15 10 00 00       	call   801049f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039db:	8b 43 18             	mov    0x18(%ebx),%eax
801039de:	ba 1b 00 00 00       	mov    $0x1b,%edx
801039e3:	83 c4 10             	add    $0x10,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039e6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ef:	8b 43 18             	mov    0x18(%ebx),%eax
801039f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039f6:	8b 43 18             	mov    0x18(%ebx),%eax
801039f9:	8d 8b 80 0e 00 00    	lea    0xe80(%ebx),%ecx
801039ff:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a03:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a07:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0a:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a0e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a12:	8b 43 18             	mov    0x18(%ebx),%eax
80103a15:	89 da                	mov    %ebx,%edx
80103a17:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a1e:	8b 43 18             	mov    0x18(%ebx),%eax
80103a21:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a28:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  for(int i=0; i<16; i++){
80103a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	p->allAddresses[i].physicalPageNumber = 0;
80103a38:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
80103a3f:	00 00 00 
	for(int j=0; j<16; j++){
80103a42:	31 c0                	xor    %eax,%eax
80103a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		p->allAddresses[i].forFork[j] = 0;
80103a48:	c7 84 82 0c 01 00 00 	movl   $0x0,0x10c(%edx,%eax,4)
80103a4f:	00 00 00 00 
80103a53:	c7 84 82 10 01 00 00 	movl   $0x0,0x110(%edx,%eax,4)
80103a5a:	00 00 00 00 
	for(int j=0; j<16; j++){
80103a5e:	83 c0 02             	add    $0x2,%eax
80103a61:	83 f8 10             	cmp    $0x10,%eax
80103a64:	75 e2                	jne    80103a48 <userinit+0xb8>
  for(int i=0; i<16; i++){
80103a66:	81 c2 e8 00 00 00    	add    $0xe8,%edx
80103a6c:	39 ca                	cmp    %ecx,%edx
80103a6e:	75 c8                	jne    80103a38 <userinit+0xa8>
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a70:	83 ec 04             	sub    $0x4,%esp
80103a73:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a76:	6a 10                	push   $0x10
80103a78:	68 c6 88 10 80       	push   $0x801088c6
80103a7d:	50                   	push   %eax
80103a7e:	e8 1d 11 00 00       	call   80104ba0 <safestrcpy>
  p->cwd = namei("/");
80103a83:	c7 04 24 cf 88 10 80 	movl   $0x801088cf,(%esp)
80103a8a:	e8 f1 e5 ff ff       	call   80102080 <namei>
80103a8f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a92:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a99:	e8 52 0e 00 00       	call   801048f0 <acquire>
  p->state = RUNNABLE;
80103a9e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aa5:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103aac:	e8 df 0d 00 00       	call   80104890 <release>
}
80103ab1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab4:	83 c4 10             	add    $0x10,%esp
80103ab7:	c9                   	leave
80103ab8:	c3                   	ret
    panic("userinit: out of memory?");
80103ab9:	83 ec 0c             	sub    $0xc,%esp
80103abc:	68 ad 88 10 80       	push   $0x801088ad
80103ac1:	e8 ba c8 ff ff       	call   80100380 <panic>
80103ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

80103ad0 <growproc>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ad8:	e8 c3 0c 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103add:	e8 fe fd ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae8:	e8 03 0d 00 00       	call   801047f0 <popcli>
  sz = curproc->sz;
80103aed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aef:	85 f6                	test   %esi,%esi
80103af1:	7f 1d                	jg     80103b10 <growproc+0x40>
  } else if(n < 0){
80103af3:	75 3b                	jne    80103b30 <growproc+0x60>
  switchuvm(curproc);
80103af5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103af8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103afa:	53                   	push   %ebx
80103afb:	e8 c0 43 00 00       	call   80107ec0 <switchuvm>
  return 0;
80103b00:	83 c4 10             	add    $0x10,%esp
80103b03:	31 c0                	xor    %eax,%eax
}
80103b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b08:	5b                   	pop    %ebx
80103b09:	5e                   	pop    %esi
80103b0a:	5d                   	pop    %ebp
80103b0b:	c3                   	ret
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 01 46 00 00       	call   80108120 <allocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 cf                	jne    80103af5 <growproc+0x25>
      return -1;
80103b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b2b:	eb d8                	jmp    80103b05 <growproc+0x35>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	push   0x4(%ebx)
80103b3a:	e8 01 47 00 00       	call   80108240 <deallocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 af                	jne    80103af5 <growproc+0x25>
80103b46:	eb de                	jmp    80103b26 <growproc+0x56>
80103b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4f:	90                   	nop

80103b50 <addPhysicalPage2>:
void addPhysicalPage2(struct proc *np, uint mappedAddress, char* mem){
80103b50:	55                   	push   %ebp
  for(int i=0; i<16; i++){
80103b51:	31 c9                	xor    %ecx,%ecx
void addPhysicalPage2(struct proc *np, uint mappedAddress, char* mem){
80103b53:	89 e5                	mov    %esp,%ebp
80103b55:	57                   	push   %edi
		  ((np->allAddresses)[i].forFork[j]) = V2P(mem);
80103b56:	8b 7d 10             	mov    0x10(%ebp),%edi
80103b59:	8b 45 08             	mov    0x8(%ebp),%eax
void addPhysicalPage2(struct proc *np, uint mappedAddress, char* mem){
80103b5c:	56                   	push   %esi
80103b5d:	53                   	push   %ebx
80103b5e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		  ((np->allAddresses)[i].forFork[j]) = V2P(mem);
80103b61:	8d b7 00 00 00 80    	lea    -0x80000000(%edi),%esi
80103b67:	eb 14                	jmp    80103b7d <addPhysicalPage2+0x2d>
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i=0; i<16; i++){
80103b70:	83 c1 01             	add    $0x1,%ecx
80103b73:	05 e8 00 00 00       	add    $0xe8,%eax
80103b78:	83 f9 10             	cmp    $0x10,%ecx
80103b7b:	74 51                	je     80103bce <addPhysicalPage2+0x7e>
    if((np->allAddresses)[i].startingVirtualAddr <= mappedAddress && (np->allAddresses)[i].endingVirtualAddr > mappedAddress){
80103b7d:	3b 58 7c             	cmp    0x7c(%eax),%ebx
80103b80:	72 ee                	jb     80103b70 <addPhysicalPage2+0x20>
80103b82:	3b 98 80 00 00 00    	cmp    0x80(%eax),%ebx
80103b88:	73 e6                	jae    80103b70 <addPhysicalPage2+0x20>
      ((np->allAddresses)[i].physicalPageNumber)++;
80103b8a:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
      for(int j=0; j<16; j++){
80103b91:	31 d2                	xor    %edx,%edx
80103b93:	eb 0b                	jmp    80103ba0 <addPhysicalPage2+0x50>
80103b95:	8d 76 00             	lea    0x0(%esi),%esi
80103b98:	83 c2 01             	add    $0x1,%edx
80103b9b:	83 fa 10             	cmp    $0x10,%edx
80103b9e:	74 d0                	je     80103b70 <addPhysicalPage2+0x20>
		if(((np->allAddresses)[i].forFork[j]) == 0){
80103ba0:	8b bc 90 0c 01 00 00 	mov    0x10c(%eax,%edx,4),%edi
80103ba7:	85 ff                	test   %edi,%edi
80103ba9:	75 ed                	jne    80103b98 <addPhysicalPage2+0x48>
		  ((np->allAddresses)[i].forFork[j]) = V2P(mem);
80103bab:	6b f9 3a             	imul   $0x3a,%ecx,%edi
  for(int i=0; i<16; i++){
80103bae:	83 c1 01             	add    $0x1,%ecx
80103bb1:	05 e8 00 00 00       	add    $0xe8,%eax
		  ((np->allAddresses)[i].forFork[j]) = V2P(mem);
80103bb6:	01 d7                	add    %edx,%edi
80103bb8:	8b 55 08             	mov    0x8(%ebp),%edx
80103bbb:	89 b4 ba 0c 01 00 00 	mov    %esi,0x10c(%edx,%edi,4)
		  np->allAddresses[i].startingPhysicalAddr[j] = V2P(mem);
80103bc2:	89 b4 ba 8c 00 00 00 	mov    %esi,0x8c(%edx,%edi,4)
  for(int i=0; i<16; i++){
80103bc9:	83 f9 10             	cmp    $0x10,%ecx
80103bcc:	75 af                	jne    80103b7d <addPhysicalPage2+0x2d>
}
80103bce:	5b                   	pop    %ebx
80103bcf:	5e                   	pop    %esi
80103bd0:	5f                   	pop    %edi
80103bd1:	5d                   	pop    %ebp
80103bd2:	c3                   	ret
80103bd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <fork>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103be9:	e8 b2 0b 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103bee:	e8 ed fc ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103bf3:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103bf9:	89 7d d8             	mov    %edi,-0x28(%ebp)
  popcli();
80103bfc:	e8 ef 0b 00 00       	call   801047f0 <popcli>
  if((np = allocproc()) == 0){
80103c01:	e8 9a fb ff ff       	call   801037a0 <allocproc>
80103c06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103c09:	85 c0                	test   %eax,%eax
80103c0b:	0f 84 eb 02 00 00    	je     80103efc <fork+0x31c>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c11:	83 ec 08             	sub    $0x8,%esp
80103c14:	ff 37                	push   (%edi)
80103c16:	89 c3                	mov    %eax,%ebx
80103c18:	ff 77 04             	push   0x4(%edi)
80103c1b:	e8 c0 47 00 00       	call   801083e0 <copyuvm>
80103c20:	83 c4 10             	add    $0x10,%esp
80103c23:	89 43 04             	mov    %eax,0x4(%ebx)
80103c26:	85 c0                	test   %eax,%eax
80103c28:	0f 84 af 02 00 00    	je     80103edd <fork+0x2fd>
  np->sz = curproc->sz;
80103c2e:	8b 7d d8             	mov    -0x28(%ebp),%edi
80103c31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  *np->tf = *curproc->tf;
80103c34:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103c39:	8b 07                	mov    (%edi),%eax
  np->parent = curproc;
80103c3b:	89 7a 14             	mov    %edi,0x14(%edx)
  np->sz = curproc->sz;
80103c3e:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103c40:	89 f8                	mov    %edi,%eax
  *np->tf = *curproc->tf;
80103c42:	8b 77 18             	mov    0x18(%edi),%esi
80103c45:	8b 7a 18             	mov    0x18(%edx),%edi
80103c48:	8d 98 80 0e 00 00    	lea    0xe80(%eax),%ebx
80103c4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		np->allAddresses[i] = curproc->allAddresses[i];
80103c50:	8d 7a 7c             	lea    0x7c(%edx),%edi
80103c53:	8d 70 7c             	lea    0x7c(%eax),%esi
80103c56:	b9 3a 00 00 00       	mov    $0x3a,%ecx
80103c5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		np->allAddresses[i].startingVirtualAddr = curproc->allAddresses[i].startingVirtualAddr;
80103c5d:	8b 48 7c             	mov    0x7c(%eax),%ecx
80103c60:	89 4a 7c             	mov    %ecx,0x7c(%edx)
		np->allAddresses[i].endingVirtualAddr = curproc->allAddresses[i].endingVirtualAddr;
80103c63:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103c69:	89 8a 80 00 00 00    	mov    %ecx,0x80(%edx)
		np->allAddresses[i].numberOfPages = curproc->allAddresses[i].numberOfPages;
80103c6f:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80103c75:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
		np->allAddresses[i].isPrivate = curproc->allAddresses[i].isPrivate;
80103c7b:	8b 88 50 01 00 00    	mov    0x150(%eax),%ecx
80103c81:	89 8a 50 01 00 00    	mov    %ecx,0x150(%edx)
		np->allAddresses[i].isAnonymous = curproc->allAddresses[i].isAnonymous;
80103c87:	8b 88 54 01 00 00    	mov    0x154(%eax),%ecx
80103c8d:	89 8a 54 01 00 00    	mov    %ecx,0x154(%edx)
		np->allAddresses[i].fd = curproc->allAddresses[i].fd;
80103c93:	8b 88 58 01 00 00    	mov    0x158(%eax),%ecx
80103c99:	89 8a 58 01 00 00    	mov    %ecx,0x158(%edx)
		if(curproc->allAddresses[i].isPrivate == 0)
80103c9f:	8b b0 50 01 00 00    	mov    0x150(%eax),%esi
80103ca5:	85 f6                	test   %esi,%esi
80103ca7:	75 15                	jne    80103cbe <fork+0xde>
			np->allAddresses[i].refCount = curproc->allAddresses[i].refCount + 1;
80103ca9:	8b b8 4c 01 00 00    	mov    0x14c(%eax),%edi
80103caf:	8d 4f 01             	lea    0x1(%edi),%ecx
80103cb2:	89 8a 4c 01 00 00    	mov    %ecx,0x14c(%edx)
				if(curproc->allAddresses[i].isPrivate == 0)
80103cb8:	8b b0 50 01 00 00    	mov    0x150(%eax),%esi
  *np->tf = *curproc->tf;
80103cbe:	31 c9                	xor    %ecx,%ecx
			if(j<16){
80103cc0:	83 f9 0f             	cmp    $0xf,%ecx
80103cc3:	7f 0c                	jg     80103cd1 <fork+0xf1>
				if(curproc->allAddresses[i].isPrivate == 0)
80103cc5:	85 f6                	test   %esi,%esi
80103cc7:	74 2f                	je     80103cf8 <fork+0x118>
		for(int j=0; j<32; j++){
80103cc9:	83 c1 01             	add    $0x1,%ecx
			if(j<16){
80103ccc:	83 f9 0f             	cmp    $0xf,%ecx
80103ccf:	7e f4                	jle    80103cc5 <fork+0xe5>
			if(curproc->allAddresses[i].isPrivate == 0)
80103cd1:	85 f6                	test   %esi,%esi
80103cd3:	75 0e                	jne    80103ce3 <fork+0x103>
				np->allAddresses[i].startingPhysicalAddr[j] = curproc->allAddresses[i].startingPhysicalAddr[j];
80103cd5:	8b b4 88 8c 00 00 00 	mov    0x8c(%eax,%ecx,4),%esi
80103cdc:	89 b4 8a 8c 00 00 00 	mov    %esi,0x8c(%edx,%ecx,4)
		for(int j=0; j<32; j++){
80103ce3:	83 c1 01             	add    $0x1,%ecx
80103ce6:	83 f9 20             	cmp    $0x20,%ecx
80103ce9:	74 55                	je     80103d40 <fork+0x160>
80103ceb:	8b b0 50 01 00 00    	mov    0x150(%eax),%esi
80103cf1:	eb cd                	jmp    80103cc0 <fork+0xe0>
80103cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf7:	90                   	nop
					np->allAddresses[i].forFork[j] = curproc->allAddresses[i].forFork[j];
80103cf8:	8b b4 88 0c 01 00 00 	mov    0x10c(%eax,%ecx,4),%esi
80103cff:	89 b4 8a 0c 01 00 00 	mov    %esi,0x10c(%edx,%ecx,4)
			if(curproc->allAddresses[i].isPrivate == 0)
80103d06:	8b b0 50 01 00 00    	mov    0x150(%eax),%esi
80103d0c:	85 f6                	test   %esi,%esi
80103d0e:	75 20                	jne    80103d30 <fork+0x150>
				np->allAddresses[i].startingPhysicalAddr[j] = curproc->allAddresses[i].startingPhysicalAddr[j];
80103d10:	8b b4 88 8c 00 00 00 	mov    0x8c(%eax,%ecx,4),%esi
80103d17:	89 b4 8a 8c 00 00 00 	mov    %esi,0x8c(%edx,%ecx,4)
		for(int j=0; j<32; j++){
80103d1e:	83 c1 01             	add    $0x1,%ecx
80103d21:	8b b0 50 01 00 00    	mov    0x150(%eax),%esi
80103d27:	eb 97                	jmp    80103cc0 <fork+0xe0>
80103d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d30:	8b b0 50 01 00 00    	mov    0x150(%eax),%esi
80103d36:	83 c1 01             	add    $0x1,%ecx
80103d39:	eb 85                	jmp    80103cc0 <fork+0xe0>
80103d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop
	for(int i=0; i<16; i++){
80103d40:	05 e8 00 00 00       	add    $0xe8,%eax
80103d45:	81 c2 e8 00 00 00    	add    $0xe8,%edx
80103d4b:	39 d8                	cmp    %ebx,%eax
80103d4d:	0f 85 fd fe ff ff    	jne    80103c50 <fork+0x70>
80103d53:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d56:	8d b8 8c 0f 00 00    	lea    0xf8c(%eax),%edi
80103d5c:	8d 90 0c 01 00 00    	lea    0x10c(%eax),%edx
80103d62:	89 7d dc             	mov    %edi,-0x24(%ebp)
80103d65:	89 d7                	mov    %edx,%edi
80103d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d6e:	66 90                	xchg   %ax,%ax
  *np->tf = *curproc->tf;
80103d70:	89 fe                	mov    %edi,%esi
80103d72:	31 db                	xor    %ebx,%ebx
80103d74:	eb 41                	jmp    80103db7 <fork+0x1d7>
80103d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
  				mappages(np->pgdir, (char*)(curproc->allAddresses[i].startingVirtualAddr + j*PGSIZE), PGSIZE, curproc->allAddresses[i].forFork[j], PTE_W | PTE_U);
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	6a 06                	push   $0x6
80103d85:	50                   	push   %eax
80103d86:	68 00 10 00 00       	push   $0x1000
80103d8b:	8b 87 70 ff ff ff    	mov    -0x90(%edi),%eax
80103d91:	01 d8                	add    %ebx,%eax
80103d93:	50                   	push   %eax
80103d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d97:	ff 70 04             	push   0x4(%eax)
80103d9a:	e8 21 40 00 00       	call   80107dc0 <mappages>
80103d9f:	83 c4 20             	add    $0x20,%esp
  	for(uint j=0; j<16; j++){
80103da2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103da8:	83 c6 04             	add    $0x4,%esi
80103dab:	81 fb 00 00 01 00    	cmp    $0x10000,%ebx
80103db1:	0f 84 89 00 00 00    	je     80103e40 <fork+0x260>
  		if(curproc->allAddresses[i].forFork[j] != 0){
80103db7:	8b 06                	mov    (%esi),%eax
80103db9:	85 c0                	test   %eax,%eax
80103dbb:	74 e5                	je     80103da2 <fork+0x1c2>
  			if(curproc->allAddresses[i].isPrivate == 0){
80103dbd:	8b 57 44             	mov    0x44(%edi),%edx
80103dc0:	85 d2                	test   %edx,%edx
80103dc2:	74 bc                	je     80103d80 <fork+0x1a0>
  				char* mem = kalloc();
80103dc4:	e8 97 e8 ff ff       	call   80102660 <kalloc>
  				memset(mem, 0, PGSIZE);
80103dc9:	83 ec 04             	sub    $0x4,%esp
80103dcc:	68 00 10 00 00       	push   $0x1000
80103dd1:	6a 00                	push   $0x0
80103dd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dd6:	50                   	push   %eax
80103dd7:	e8 14 0c 00 00       	call   801049f0 <memset>
  				mappages(np->pgdir, (char*)(curproc->allAddresses[i].startingVirtualAddr + j*PGSIZE), PGSIZE, V2P(mem), PTE_W | PTE_U);
80103ddc:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80103de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103de6:	05 00 00 00 80       	add    $0x80000000,%eax
80103deb:	50                   	push   %eax
80103dec:	68 00 10 00 00       	push   $0x1000
80103df1:	8b 97 70 ff ff ff    	mov    -0x90(%edi),%edx
80103df7:	01 da                	add    %ebx,%edx
80103df9:	52                   	push   %edx
80103dfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103dfd:	ff 72 04             	push   0x4(%edx)
80103e00:	e8 bb 3f 00 00       	call   80107dc0 <mappages>
				addPhysicalPage2(np, (curproc->allAddresses[i].startingVirtualAddr + j*PGSIZE), mem);
80103e05:	83 c4 1c             	add    $0x1c,%esp
80103e08:	ff 75 e4             	push   -0x1c(%ebp)
80103e0b:	8b 87 70 ff ff ff    	mov    -0x90(%edi),%eax
80103e11:	01 d8                	add    %ebx,%eax
80103e13:	50                   	push   %eax
80103e14:	ff 75 e0             	push   -0x20(%ebp)
80103e17:	e8 34 fd ff ff       	call   80103b50 <addPhysicalPage2>
				memmove(mem, P2V(curproc->allAddresses[i].forFork[j]), PGSIZE);
80103e1c:	83 c4 0c             	add    $0xc,%esp
80103e1f:	68 00 10 00 00       	push   $0x1000
80103e24:	8b 16                	mov    (%esi),%edx
80103e26:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80103e2c:	50                   	push   %eax
80103e2d:	ff 75 e4             	push   -0x1c(%ebp)
80103e30:	e8 4b 0c 00 00       	call   80104a80 <memmove>
80103e35:	83 c4 10             	add    $0x10,%esp
80103e38:	e9 65 ff ff ff       	jmp    80103da2 <fork+0x1c2>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i=0; i<16; i++){
80103e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e43:	81 c7 e8 00 00 00    	add    $0xe8,%edi
80103e49:	39 c7                	cmp    %eax,%edi
80103e4b:	0f 85 1f ff ff ff    	jne    80103d70 <fork+0x190>
  np->tf->eax = 0;
80103e51:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
80103e54:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80103e57:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e59:	8b 47 18             	mov    0x18(%edi),%eax
80103e5c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e67:	90                   	nop
    if(curproc->ofile[i]){
80103e68:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e6c:	85 c0                	test   %eax,%eax
80103e6e:	74 10                	je     80103e80 <fork+0x2a0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	50                   	push   %eax
80103e74:	e8 47 d0 ff ff       	call   80100ec0 <filedup>
80103e79:	83 c4 10             	add    $0x10,%esp
80103e7c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e80:	83 c6 01             	add    $0x1,%esi
80103e83:	83 fe 10             	cmp    $0x10,%esi
80103e86:	75 e0                	jne    80103e68 <fork+0x288>
  np->cwd = idup(curproc->cwd);
80103e88:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80103e8b:	83 ec 0c             	sub    $0xc,%esp
80103e8e:	ff 73 68             	push   0x68(%ebx)
80103e91:	e8 da d8 ff ff       	call   80101770 <idup>
80103e96:	8b 7d e0             	mov    -0x20(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e99:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e9c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e9f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ea2:	6a 10                	push   $0x10
80103ea4:	50                   	push   %eax
80103ea5:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ea8:	50                   	push   %eax
80103ea9:	e8 f2 0c 00 00       	call   80104ba0 <safestrcpy>
  pid = np->pid;
80103eae:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103eb1:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103eb8:	e8 33 0a 00 00       	call   801048f0 <acquire>
  np->state = RUNNABLE;
80103ebd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103ec4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ecb:	e8 c0 09 00 00       	call   80104890 <release>
  return pid;
80103ed0:	83 c4 10             	add    $0x10,%esp
}
80103ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ed6:	89 f0                	mov    %esi,%eax
80103ed8:	5b                   	pop    %ebx
80103ed9:	5e                   	pop    %esi
80103eda:	5f                   	pop    %edi
80103edb:	5d                   	pop    %ebp
80103edc:	c3                   	ret
    kfree(np->kstack);
80103edd:	8b 7d e0             	mov    -0x20(%ebp),%edi
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	ff 77 08             	push   0x8(%edi)
80103ee6:	e8 b5 e5 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103eeb:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103ef2:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ef5:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103efc:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103f01:	eb d0                	jmp    80103ed3 <fork+0x2f3>
80103f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f10 <scheduler>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f19:	e8 c2 f9 ff ff       	call   801038e0 <mycpu>
  c->proc = 0;
80103f1e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f25:	00 00 00 
  struct cpu *c = mycpu();
80103f28:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f2a:	8d 78 04             	lea    0x4(%eax),%edi
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f30:	fb                   	sti
    acquire(&ptable.lock);
80103f31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f34:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103f39:	68 20 3d 11 80       	push   $0x80113d20
80103f3e:	e8 ad 09 00 00       	call   801048f0 <acquire>
80103f43:	83 c4 10             	add    $0x10,%esp
80103f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f54:	75 33                	jne    80103f89 <scheduler+0x79>
      switchuvm(p);
80103f56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f5f:	53                   	push   %ebx
80103f60:	e8 5b 3f 00 00       	call   80107ec0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f65:	58                   	pop    %eax
80103f66:	5a                   	pop    %edx
80103f67:	ff 73 1c             	push   0x1c(%ebx)
80103f6a:	57                   	push   %edi
      p->state = RUNNING;
80103f6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f72:	e8 84 0c 00 00       	call   80104bfb <swtch>
      switchkvm();
80103f77:	e8 34 3f 00 00       	call   80107eb0 <switchkvm>
      c->proc = 0;
80103f7c:	83 c4 10             	add    $0x10,%esp
80103f7f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f86:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f89:	81 c3 fc 0e 00 00    	add    $0xefc,%ebx
80103f8f:	81 fb 54 fc 14 80    	cmp    $0x8014fc54,%ebx
80103f95:	75 b9                	jne    80103f50 <scheduler+0x40>
    release(&ptable.lock);
80103f97:	83 ec 0c             	sub    $0xc,%esp
80103f9a:	68 20 3d 11 80       	push   $0x80113d20
80103f9f:	e8 ec 08 00 00       	call   80104890 <release>
    sti();
80103fa4:	83 c4 10             	add    $0x10,%esp
80103fa7:	eb 87                	jmp    80103f30 <scheduler+0x20>
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fb0 <sched>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
  pushcli();
80103fb5:	e8 e6 07 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103fba:	e8 21 f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103fbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fc5:	e8 26 08 00 00       	call   801047f0 <popcli>
  if(!holding(&ptable.lock))
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 20 3d 11 80       	push   $0x80113d20
80103fd2:	e8 79 08 00 00       	call   80104850 <holding>
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 4f                	je     8010402d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fde:	e8 fd f8 ff ff       	call   801038e0 <mycpu>
80103fe3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fea:	75 68                	jne    80104054 <sched+0xa4>
  if(p->state == RUNNING)
80103fec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ff0:	74 55                	je     80104047 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ff2:	9c                   	pushf
80103ff3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ff4:	f6 c4 02             	test   $0x2,%ah
80103ff7:	75 41                	jne    8010403a <sched+0x8a>
  intena = mycpu()->intena;
80103ff9:	e8 e2 f8 ff ff       	call   801038e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ffe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104001:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104007:	e8 d4 f8 ff ff       	call   801038e0 <mycpu>
8010400c:	83 ec 08             	sub    $0x8,%esp
8010400f:	ff 70 04             	push   0x4(%eax)
80104012:	53                   	push   %ebx
80104013:	e8 e3 0b 00 00       	call   80104bfb <swtch>
  mycpu()->intena = intena;
80104018:	e8 c3 f8 ff ff       	call   801038e0 <mycpu>
}
8010401d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104020:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
8010402c:	c3                   	ret
    panic("sched ptable.lock");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 d1 88 10 80       	push   $0x801088d1
80104035:	e8 46 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 fd 88 10 80       	push   $0x801088fd
80104042:	e8 39 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104047:	83 ec 0c             	sub    $0xc,%esp
8010404a:	68 ef 88 10 80       	push   $0x801088ef
8010404f:	e8 2c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	68 e3 88 10 80       	push   $0x801088e3
8010405c:	e8 1f c3 ff ff       	call   80100380 <panic>
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop

80104070 <exit>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80104079:	e8 e2 f8 ff ff       	call   80103960 <myproc>
  if(curproc == initproc)
8010407e:	39 05 54 fc 14 80    	cmp    %eax,0x8014fc54
80104084:	0f 84 57 01 00 00    	je     801041e1 <exit+0x171>
8010408a:	89 c3                	mov    %eax,%ebx
8010408c:	8d 70 7c             	lea    0x7c(%eax),%esi
8010408f:	8d 80 fc 0e 00 00    	lea    0xefc(%eax),%eax
80104095:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
{
801040a0:	31 ff                	xor    %edi,%edi
801040a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
   	  		pte_t* pte = (pte_t*)walkpgdir(curproc->pgdir, (char*)tempAddr, 0);
801040a8:	83 ec 04             	sub    $0x4,%esp
801040ab:	6a 00                	push   $0x0
   	  		uint tempAddr = startingAddr + a*PGSIZE;
801040ad:	8b 06                	mov    (%esi),%eax
801040af:	01 f8                	add    %edi,%eax
   	  		pte_t* pte = (pte_t*)walkpgdir(curproc->pgdir, (char*)tempAddr, 0);
801040b1:	50                   	push   %eax
801040b2:	ff 73 04             	push   0x4(%ebx)
801040b5:	e8 76 3c 00 00       	call   80107d30 <walkpgdir>
   	  		if((*pte & PTE_P)){
801040ba:	83 c4 10             	add    $0x10,%esp
801040bd:	f6 00 01             	testb  $0x1,(%eax)
801040c0:	74 06                	je     801040c8 <exit+0x58>
   	  			*pte = 0;
801040c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   	  	for(int a=0; a<16; a++){
801040c8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801040ce:	81 ff 00 00 01 00    	cmp    $0x10000,%edi
801040d4:	75 d2                	jne    801040a8 <exit+0x38>
   	for(int i=0; i<16; i++){
801040d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040d9:	81 c6 e8 00 00 00    	add    $0xe8,%esi
801040df:	39 c6                	cmp    %eax,%esi
801040e1:	75 bd                	jne    801040a0 <exit+0x30>
801040e3:	8d 73 28             	lea    0x28(%ebx),%esi
801040e6:	8d 7b 68             	lea    0x68(%ebx),%edi
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801040f0:	8b 06                	mov    (%esi),%eax
801040f2:	85 c0                	test   %eax,%eax
801040f4:	74 12                	je     80104108 <exit+0x98>
      fileclose(curproc->ofile[fd]);
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	50                   	push   %eax
801040fa:	e8 11 ce ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
801040ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104105:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104108:	83 c6 04             	add    $0x4,%esi
8010410b:	39 f7                	cmp    %esi,%edi
8010410d:	75 e1                	jne    801040f0 <exit+0x80>
  begin_op();
8010410f:	e8 2c ec ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	ff 73 68             	push   0x68(%ebx)
8010411a:	e8 b1 d7 ff ff       	call   801018d0 <iput>
  end_op();
8010411f:	e8 8c ec ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80104124:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010412b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104132:	e8 b9 07 00 00       	call   801048f0 <acquire>
  wakeup1(curproc->parent);
80104137:	8b 53 14             	mov    0x14(%ebx),%edx
8010413a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104142:	eb 10                	jmp    80104154 <exit+0xe4>
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104148:	05 fc 0e 00 00       	add    $0xefc,%eax
8010414d:	3d 54 fc 14 80       	cmp    $0x8014fc54,%eax
80104152:	74 1e                	je     80104172 <exit+0x102>
    if(p->state == SLEEPING && p->chan == chan)
80104154:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104158:	75 ee                	jne    80104148 <exit+0xd8>
8010415a:	3b 50 20             	cmp    0x20(%eax),%edx
8010415d:	75 e9                	jne    80104148 <exit+0xd8>
      p->state = RUNNABLE;
8010415f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104166:	05 fc 0e 00 00       	add    $0xefc,%eax
8010416b:	3d 54 fc 14 80       	cmp    $0x8014fc54,%eax
80104170:	75 e2                	jne    80104154 <exit+0xe4>
      p->parent = initproc;
80104172:	8b 0d 54 fc 14 80    	mov    0x8014fc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104178:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010417d:	eb 0f                	jmp    8010418e <exit+0x11e>
8010417f:	90                   	nop
80104180:	81 c2 fc 0e 00 00    	add    $0xefc,%edx
80104186:	81 fa 54 fc 14 80    	cmp    $0x8014fc54,%edx
8010418c:	74 3a                	je     801041c8 <exit+0x158>
    if(p->parent == curproc){
8010418e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104191:	75 ed                	jne    80104180 <exit+0x110>
      if(p->state == ZOMBIE)
80104193:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104197:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010419a:	75 e4                	jne    80104180 <exit+0x110>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041a1:	eb 11                	jmp    801041b4 <exit+0x144>
801041a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a7:	90                   	nop
801041a8:	05 fc 0e 00 00       	add    $0xefc,%eax
801041ad:	3d 54 fc 14 80       	cmp    $0x8014fc54,%eax
801041b2:	74 cc                	je     80104180 <exit+0x110>
    if(p->state == SLEEPING && p->chan == chan)
801041b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041b8:	75 ee                	jne    801041a8 <exit+0x138>
801041ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801041bd:	75 e9                	jne    801041a8 <exit+0x138>
      p->state = RUNNABLE;
801041bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041c6:	eb e0                	jmp    801041a8 <exit+0x138>
  curproc->state = ZOMBIE;
801041c8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801041cf:	e8 dc fd ff ff       	call   80103fb0 <sched>
  panic("zombie exit");
801041d4:	83 ec 0c             	sub    $0xc,%esp
801041d7:	68 1e 89 10 80       	push   $0x8010891e
801041dc:	e8 9f c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
801041e1:	83 ec 0c             	sub    $0xc,%esp
801041e4:	68 11 89 10 80       	push   $0x80108911
801041e9:	e8 92 c1 ff ff       	call   80100380 <panic>
801041ee:	66 90                	xchg   %ax,%ax

801041f0 <wait>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
  pushcli();
801041f5:	e8 a6 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
801041fa:	e8 e1 f6 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
801041ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104205:	e8 e6 05 00 00       	call   801047f0 <popcli>
  acquire(&ptable.lock);
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 20 3d 11 80       	push   $0x80113d20
80104212:	e8 d9 06 00 00       	call   801048f0 <acquire>
80104217:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010421a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104221:	eb 13                	jmp    80104236 <wait+0x46>
80104223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104227:	90                   	nop
80104228:	81 c3 fc 0e 00 00    	add    $0xefc,%ebx
8010422e:	81 fb 54 fc 14 80    	cmp    $0x8014fc54,%ebx
80104234:	74 1e                	je     80104254 <wait+0x64>
      if(p->parent != curproc)
80104236:	39 73 14             	cmp    %esi,0x14(%ebx)
80104239:	75 ed                	jne    80104228 <wait+0x38>
      if(p->state == ZOMBIE){
8010423b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010423f:	74 5f                	je     801042a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104241:	81 c3 fc 0e 00 00    	add    $0xefc,%ebx
      havekids = 1;
80104247:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010424c:	81 fb 54 fc 14 80    	cmp    $0x8014fc54,%ebx
80104252:	75 e2                	jne    80104236 <wait+0x46>
    if(!havekids || curproc->killed){
80104254:	85 c0                	test   %eax,%eax
80104256:	0f 84 9a 00 00 00    	je     801042f6 <wait+0x106>
8010425c:	8b 46 24             	mov    0x24(%esi),%eax
8010425f:	85 c0                	test   %eax,%eax
80104261:	0f 85 8f 00 00 00    	jne    801042f6 <wait+0x106>
  pushcli();
80104267:	e8 34 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010426c:	e8 6f f6 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80104271:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104277:	e8 74 05 00 00       	call   801047f0 <popcli>
  if(p == 0)
8010427c:	85 db                	test   %ebx,%ebx
8010427e:	0f 84 89 00 00 00    	je     8010430d <wait+0x11d>
  p->chan = chan;
80104284:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104287:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010428e:	e8 1d fd ff ff       	call   80103fb0 <sched>
  p->chan = 0;
80104293:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010429a:	e9 7b ff ff ff       	jmp    8010421a <wait+0x2a>
8010429f:	90                   	nop
        kfree(p->kstack);
801042a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042a6:	ff 73 08             	push   0x8(%ebx)
801042a9:	e8 f2 e1 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
801042ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042b5:	5a                   	pop    %edx
801042b6:	ff 73 04             	push   0x4(%ebx)
801042b9:	e8 b2 3f 00 00       	call   80108270 <freevm>
        p->pid = 0;
801042be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042de:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042e5:	e8 a6 05 00 00       	call   80104890 <release>
        return pid;
801042ea:	83 c4 10             	add    $0x10,%esp
}
801042ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042f0:	89 f0                	mov    %esi,%eax
801042f2:	5b                   	pop    %ebx
801042f3:	5e                   	pop    %esi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret
      release(&ptable.lock);
801042f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042fe:	68 20 3d 11 80       	push   $0x80113d20
80104303:	e8 88 05 00 00       	call   80104890 <release>
      return -1;
80104308:	83 c4 10             	add    $0x10,%esp
8010430b:	eb e0                	jmp    801042ed <wait+0xfd>
    panic("sleep");
8010430d:	83 ec 0c             	sub    $0xc,%esp
80104310:	68 2a 89 10 80       	push   $0x8010892a
80104315:	e8 66 c0 ff ff       	call   80100380 <panic>
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <yield>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104327:	68 20 3d 11 80       	push   $0x80113d20
8010432c:	e8 bf 05 00 00       	call   801048f0 <acquire>
  pushcli();
80104331:	e8 6a 04 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80104336:	e8 a5 f5 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
8010433b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104341:	e8 aa 04 00 00       	call   801047f0 <popcli>
  myproc()->state = RUNNABLE;
80104346:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010434d:	e8 5e fc ff ff       	call   80103fb0 <sched>
  release(&ptable.lock);
80104352:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104359:	e8 32 05 00 00       	call   80104890 <release>
}
8010435e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104361:	83 c4 10             	add    $0x10,%esp
80104364:	c9                   	leave
80104365:	c3                   	ret
80104366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436d:	8d 76 00             	lea    0x0(%esi),%esi

80104370 <sleep>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	56                   	push   %esi
80104375:	53                   	push   %ebx
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	8b 7d 08             	mov    0x8(%ebp),%edi
8010437c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010437f:	e8 1c 04 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80104384:	e8 57 f5 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80104389:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010438f:	e8 5c 04 00 00       	call   801047f0 <popcli>
  if(p == 0)
80104394:	85 db                	test   %ebx,%ebx
80104396:	0f 84 87 00 00 00    	je     80104423 <sleep+0xb3>
  if(lk == 0)
8010439c:	85 f6                	test   %esi,%esi
8010439e:	74 76                	je     80104416 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043a0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801043a6:	74 50                	je     801043f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	68 20 3d 11 80       	push   $0x80113d20
801043b0:	e8 3b 05 00 00       	call   801048f0 <acquire>
    release(lk);
801043b5:	89 34 24             	mov    %esi,(%esp)
801043b8:	e8 d3 04 00 00       	call   80104890 <release>
  p->chan = chan;
801043bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043c7:	e8 e4 fb ff ff       	call   80103fb0 <sched>
  p->chan = 0;
801043cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043d3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801043da:	e8 b1 04 00 00       	call   80104890 <release>
    acquire(lk);
801043df:	89 75 08             	mov    %esi,0x8(%ebp)
801043e2:	83 c4 10             	add    $0x10,%esp
}
801043e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e8:	5b                   	pop    %ebx
801043e9:	5e                   	pop    %esi
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
    acquire(lk);
801043ec:	e9 ff 04 00 00       	jmp    801048f0 <acquire>
801043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104402:	e8 a9 fb ff ff       	call   80103fb0 <sched>
  p->chan = 0;
80104407:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010440e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104411:	5b                   	pop    %ebx
80104412:	5e                   	pop    %esi
80104413:	5f                   	pop    %edi
80104414:	5d                   	pop    %ebp
80104415:	c3                   	ret
    panic("sleep without lk");
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	68 30 89 10 80       	push   $0x80108930
8010441e:	e8 5d bf ff ff       	call   80100380 <panic>
    panic("sleep");
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	68 2a 89 10 80       	push   $0x8010892a
8010442b:	e8 50 bf ff ff       	call   80100380 <panic>

80104430 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 10             	sub    $0x10,%esp
80104437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010443a:	68 20 3d 11 80       	push   $0x80113d20
8010443f:	e8 ac 04 00 00       	call   801048f0 <acquire>
80104444:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104447:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010444c:	eb 0e                	jmp    8010445c <wakeup+0x2c>
8010444e:	66 90                	xchg   %ax,%ax
80104450:	05 fc 0e 00 00       	add    $0xefc,%eax
80104455:	3d 54 fc 14 80       	cmp    $0x8014fc54,%eax
8010445a:	74 1e                	je     8010447a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010445c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104460:	75 ee                	jne    80104450 <wakeup+0x20>
80104462:	3b 58 20             	cmp    0x20(%eax),%ebx
80104465:	75 e9                	jne    80104450 <wakeup+0x20>
      p->state = RUNNABLE;
80104467:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010446e:	05 fc 0e 00 00       	add    $0xefc,%eax
80104473:	3d 54 fc 14 80       	cmp    $0x8014fc54,%eax
80104478:	75 e2                	jne    8010445c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010447a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104481:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104484:	c9                   	leave
  release(&ptable.lock);
80104485:	e9 06 04 00 00       	jmp    80104890 <release>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 10             	sub    $0x10,%esp
80104497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010449a:	68 20 3d 11 80       	push   $0x80113d20
8010449f:	e8 4c 04 00 00       	call   801048f0 <acquire>
801044a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044ac:	eb 0e                	jmp    801044bc <kill+0x2c>
801044ae:	66 90                	xchg   %ax,%ax
801044b0:	05 fc 0e 00 00       	add    $0xefc,%eax
801044b5:	3d 54 fc 14 80       	cmp    $0x8014fc54,%eax
801044ba:	74 34                	je     801044f0 <kill+0x60>
    if(p->pid == pid){
801044bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801044bf:	75 ef                	jne    801044b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044cc:	75 07                	jne    801044d5 <kill+0x45>
        p->state = RUNNABLE;
801044ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044d5:	83 ec 0c             	sub    $0xc,%esp
801044d8:	68 20 3d 11 80       	push   $0x80113d20
801044dd:	e8 ae 03 00 00       	call   80104890 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044e5:	83 c4 10             	add    $0x10,%esp
801044e8:	31 c0                	xor    %eax,%eax
}
801044ea:	c9                   	leave
801044eb:	c3                   	ret
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	68 20 3d 11 80       	push   $0x80113d20
801044f8:	e8 93 03 00 00       	call   80104890 <release>
}
801044fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104500:	83 c4 10             	add    $0x10,%esp
80104503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104508:	c9                   	leave
80104509:	c3                   	ret
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104518:	53                   	push   %ebx
80104519:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010451e:	83 ec 3c             	sub    $0x3c,%esp
80104521:	eb 27                	jmp    8010454a <procdump+0x3a>
80104523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104527:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	68 54 8b 10 80       	push   $0x80108b54
80104530:	e8 7b c1 ff ff       	call   801006b0 <cprintf>
80104535:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104538:	81 c3 fc 0e 00 00    	add    $0xefc,%ebx
8010453e:	81 fb c0 fc 14 80    	cmp    $0x8014fcc0,%ebx
80104544:	0f 84 7e 00 00 00    	je     801045c8 <procdump+0xb8>
    if(p->state == UNUSED)
8010454a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010454d:	85 c0                	test   %eax,%eax
8010454f:	74 e7                	je     80104538 <procdump+0x28>
      state = "???";
80104551:	ba 41 89 10 80       	mov    $0x80108941,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104556:	83 f8 05             	cmp    $0x5,%eax
80104559:	77 11                	ja     8010456c <procdump+0x5c>
8010455b:	8b 14 85 e0 8f 10 80 	mov    -0x7fef7020(,%eax,4),%edx
      state = "???";
80104562:	b8 41 89 10 80       	mov    $0x80108941,%eax
80104567:	85 d2                	test   %edx,%edx
80104569:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010456c:	53                   	push   %ebx
8010456d:	52                   	push   %edx
8010456e:	ff 73 a4             	push   -0x5c(%ebx)
80104571:	68 45 89 10 80       	push   $0x80108945
80104576:	e8 35 c1 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
8010457b:	83 c4 10             	add    $0x10,%esp
8010457e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104582:	75 a4                	jne    80104528 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104584:	83 ec 08             	sub    $0x8,%esp
80104587:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010458a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010458d:	50                   	push   %eax
8010458e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104591:	8b 40 0c             	mov    0xc(%eax),%eax
80104594:	83 c0 08             	add    $0x8,%eax
80104597:	50                   	push   %eax
80104598:	e8 83 01 00 00       	call   80104720 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010459d:	83 c4 10             	add    $0x10,%esp
801045a0:	8b 17                	mov    (%edi),%edx
801045a2:	85 d2                	test   %edx,%edx
801045a4:	74 82                	je     80104528 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801045ac:	52                   	push   %edx
801045ad:	68 81 86 10 80       	push   $0x80108681
801045b2:	e8 f9 c0 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045b7:	83 c4 10             	add    $0x10,%esp
801045ba:	39 f7                	cmp    %esi,%edi
801045bc:	75 e2                	jne    801045a0 <procdump+0x90>
801045be:	e9 65 ff ff ff       	jmp    80104528 <procdump+0x18>
801045c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c7:	90                   	nop
  }
}
801045c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045cb:	5b                   	pop    %ebx
801045cc:	5e                   	pop    %esi
801045cd:	5f                   	pop    %edi
801045ce:	5d                   	pop    %ebp
801045cf:	c3                   	ret

801045d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 0c             	sub    $0xc,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045da:	68 78 89 10 80       	push   $0x80108978
801045df:	8d 43 04             	lea    0x4(%ebx),%eax
801045e2:	50                   	push   %eax
801045e3:	e8 18 01 00 00       	call   80104700 <initlock>
  lk->name = name;
801045e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104601:	c9                   	leave
80104602:	c3                   	ret
80104603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104610 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104618:	8d 73 04             	lea    0x4(%ebx),%esi
8010461b:	83 ec 0c             	sub    $0xc,%esp
8010461e:	56                   	push   %esi
8010461f:	e8 cc 02 00 00       	call   801048f0 <acquire>
  while (lk->locked) {
80104624:	8b 13                	mov    (%ebx),%edx
80104626:	83 c4 10             	add    $0x10,%esp
80104629:	85 d2                	test   %edx,%edx
8010462b:	74 16                	je     80104643 <acquiresleep+0x33>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104630:	83 ec 08             	sub    $0x8,%esp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	e8 36 fd ff ff       	call   80104370 <sleep>
  while (lk->locked) {
8010463a:	8b 03                	mov    (%ebx),%eax
8010463c:	83 c4 10             	add    $0x10,%esp
8010463f:	85 c0                	test   %eax,%eax
80104641:	75 ed                	jne    80104630 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104643:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104649:	e8 12 f3 ff ff       	call   80103960 <myproc>
8010464e:	8b 40 10             	mov    0x10(%eax),%eax
80104651:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104654:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104657:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010465a:	5b                   	pop    %ebx
8010465b:	5e                   	pop    %esi
8010465c:	5d                   	pop    %ebp
  release(&lk->lk);
8010465d:	e9 2e 02 00 00       	jmp    80104890 <release>
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104678:	8d 73 04             	lea    0x4(%ebx),%esi
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	56                   	push   %esi
8010467f:	e8 6c 02 00 00       	call   801048f0 <acquire>
  lk->locked = 0;
80104684:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010468a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104691:	89 1c 24             	mov    %ebx,(%esp)
80104694:	e8 97 fd ff ff       	call   80104430 <wakeup>
  release(&lk->lk);
80104699:	89 75 08             	mov    %esi,0x8(%ebp)
8010469c:	83 c4 10             	add    $0x10,%esp
}
8010469f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a2:	5b                   	pop    %ebx
801046a3:	5e                   	pop    %esi
801046a4:	5d                   	pop    %ebp
  release(&lk->lk);
801046a5:	e9 e6 01 00 00       	jmp    80104890 <release>
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	31 ff                	xor    %edi,%edi
801046b6:	56                   	push   %esi
801046b7:	53                   	push   %ebx
801046b8:	83 ec 18             	sub    $0x18,%esp
801046bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046be:	8d 73 04             	lea    0x4(%ebx),%esi
801046c1:	56                   	push   %esi
801046c2:	e8 29 02 00 00       	call   801048f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046c7:	8b 03                	mov    (%ebx),%eax
801046c9:	83 c4 10             	add    $0x10,%esp
801046cc:	85 c0                	test   %eax,%eax
801046ce:	75 18                	jne    801046e8 <holdingsleep+0x38>
  release(&lk->lk);
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	56                   	push   %esi
801046d4:	e8 b7 01 00 00       	call   80104890 <release>
  return r;
}
801046d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046dc:	89 f8                	mov    %edi,%eax
801046de:	5b                   	pop    %ebx
801046df:	5e                   	pop    %esi
801046e0:	5f                   	pop    %edi
801046e1:	5d                   	pop    %ebp
801046e2:	c3                   	ret
801046e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801046e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046eb:	e8 70 f2 ff ff       	call   80103960 <myproc>
801046f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801046f3:	0f 94 c0             	sete   %al
801046f6:	0f b6 c0             	movzbl %al,%eax
801046f9:	89 c7                	mov    %eax,%edi
801046fb:	eb d3                	jmp    801046d0 <holdingsleep+0x20>
801046fd:	66 90                	xchg   %ax,%ax
801046ff:	90                   	nop

80104700 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104706:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010470f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104712:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop

80104720 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	8b 45 08             	mov    0x8(%ebp),%eax
80104727:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010472a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010472d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104732:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104737:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010473c:	76 10                	jbe    8010474e <getcallerpcs+0x2e>
8010473e:	eb 28                	jmp    80104768 <getcallerpcs+0x48>
80104740:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104746:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010474c:	77 1a                	ja     80104768 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010474e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104751:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104754:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104757:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104759:	83 f8 0a             	cmp    $0xa,%eax
8010475c:	75 e2                	jne    80104740 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010475e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104761:	c9                   	leave
80104762:	c3                   	ret
80104763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104767:	90                   	nop
80104768:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010476b:	83 c1 28             	add    $0x28,%ecx
8010476e:	89 ca                	mov    %ecx,%edx
80104770:	29 c2                	sub    %eax,%edx
80104772:	83 e2 04             	and    $0x4,%edx
80104775:	74 11                	je     80104788 <getcallerpcs+0x68>
    pcs[i] = 0;
80104777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010477d:	83 c0 04             	add    $0x4,%eax
80104780:	39 c1                	cmp    %eax,%ecx
80104782:	74 da                	je     8010475e <getcallerpcs+0x3e>
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104788:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010478e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104791:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104798:	39 c1                	cmp    %eax,%ecx
8010479a:	75 ec                	jne    80104788 <getcallerpcs+0x68>
8010479c:	eb c0                	jmp    8010475e <getcallerpcs+0x3e>
8010479e:	66 90                	xchg   %ax,%ax

801047a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
801047a7:	9c                   	pushf
801047a8:	5b                   	pop    %ebx
  asm volatile("cli");
801047a9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047aa:	e8 31 f1 ff ff       	call   801038e0 <mycpu>
801047af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047b5:	85 c0                	test   %eax,%eax
801047b7:	74 17                	je     801047d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047b9:	e8 22 f1 ff ff       	call   801038e0 <mycpu>
801047be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c8:	c9                   	leave
801047c9:	c3                   	ret
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801047d0:	e8 0b f1 ff ff       	call   801038e0 <mycpu>
801047d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047e1:	eb d6                	jmp    801047b9 <pushcli+0x19>
801047e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <popcli>:

void
popcli(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047f6:	9c                   	pushf
801047f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047f8:	f6 c4 02             	test   $0x2,%ah
801047fb:	75 35                	jne    80104832 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047fd:	e8 de f0 ff ff       	call   801038e0 <mycpu>
80104802:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104809:	78 34                	js     8010483f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010480b:	e8 d0 f0 ff ff       	call   801038e0 <mycpu>
80104810:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104816:	85 d2                	test   %edx,%edx
80104818:	74 06                	je     80104820 <popcli+0x30>
    sti();
}
8010481a:	c9                   	leave
8010481b:	c3                   	ret
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104820:	e8 bb f0 ff ff       	call   801038e0 <mycpu>
80104825:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010482b:	85 c0                	test   %eax,%eax
8010482d:	74 eb                	je     8010481a <popcli+0x2a>
  asm volatile("sti");
8010482f:	fb                   	sti
}
80104830:	c9                   	leave
80104831:	c3                   	ret
    panic("popcli - interruptible");
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 83 89 10 80       	push   $0x80108983
8010483a:	e8 41 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010483f:	83 ec 0c             	sub    $0xc,%esp
80104842:	68 9a 89 10 80       	push   $0x8010899a
80104847:	e8 34 bb ff ff       	call   80100380 <panic>
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <holding>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 75 08             	mov    0x8(%ebp),%esi
80104858:	31 db                	xor    %ebx,%ebx
  pushcli();
8010485a:	e8 41 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010485f:	8b 06                	mov    (%esi),%eax
80104861:	85 c0                	test   %eax,%eax
80104863:	75 0b                	jne    80104870 <holding+0x20>
  popcli();
80104865:	e8 86 ff ff ff       	call   801047f0 <popcli>
}
8010486a:	89 d8                	mov    %ebx,%eax
8010486c:	5b                   	pop    %ebx
8010486d:	5e                   	pop    %esi
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104870:	8b 5e 08             	mov    0x8(%esi),%ebx
80104873:	e8 68 f0 ff ff       	call   801038e0 <mycpu>
80104878:	39 c3                	cmp    %eax,%ebx
8010487a:	0f 94 c3             	sete   %bl
  popcli();
8010487d:	e8 6e ff ff ff       	call   801047f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104882:	0f b6 db             	movzbl %bl,%ebx
}
80104885:	89 d8                	mov    %ebx,%eax
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <release>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104898:	e8 03 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010489d:	8b 03                	mov    (%ebx),%eax
8010489f:	85 c0                	test   %eax,%eax
801048a1:	75 15                	jne    801048b8 <release+0x28>
  popcli();
801048a3:	e8 48 ff ff ff       	call   801047f0 <popcli>
    panic("release");
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 a1 89 10 80       	push   $0x801089a1
801048b0:	e8 cb ba ff ff       	call   80100380 <panic>
801048b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048b8:	8b 73 08             	mov    0x8(%ebx),%esi
801048bb:	e8 20 f0 ff ff       	call   801038e0 <mycpu>
801048c0:	39 c6                	cmp    %eax,%esi
801048c2:	75 df                	jne    801048a3 <release+0x13>
  popcli();
801048c4:	e8 27 ff ff ff       	call   801047f0 <popcli>
  lk->pcs[0] = 0;
801048c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5d                   	pop    %ebp
  popcli();
801048e8:	e9 03 ff ff ff       	jmp    801047f0 <popcli>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <acquire>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048f7:	e8 a4 fe ff ff       	call   801047a0 <pushcli>
  if(holding(lk))
801048fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048ff:	e8 9c fe ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104904:	8b 03                	mov    (%ebx),%eax
80104906:	85 c0                	test   %eax,%eax
80104908:	0f 85 b2 00 00 00    	jne    801049c0 <acquire+0xd0>
  popcli();
8010490e:	e8 dd fe ff ff       	call   801047f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104913:	b9 01 00 00 00       	mov    $0x1,%ecx
80104918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104920:	8b 55 08             	mov    0x8(%ebp),%edx
80104923:	89 c8                	mov    %ecx,%eax
80104925:	f0 87 02             	lock xchg %eax,(%edx)
80104928:	85 c0                	test   %eax,%eax
8010492a:	75 f4                	jne    80104920 <acquire+0x30>
  __sync_synchronize();
8010492c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104934:	e8 a7 ef ff ff       	call   801038e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010493c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010493e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104941:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104947:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010494c:	77 32                	ja     80104980 <acquire+0x90>
  ebp = (uint*)v - 2;
8010494e:	89 e8                	mov    %ebp,%eax
80104950:	eb 14                	jmp    80104966 <acquire+0x76>
80104952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104958:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010495e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104964:	77 1a                	ja     80104980 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104966:	8b 58 04             	mov    0x4(%eax),%ebx
80104969:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010496d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104970:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104972:	83 fa 0a             	cmp    $0xa,%edx
80104975:	75 e1                	jne    80104958 <acquire+0x68>
}
80104977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010497a:	c9                   	leave
8010497b:	c3                   	ret
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104980:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104984:	83 c1 34             	add    $0x34,%ecx
80104987:	89 ca                	mov    %ecx,%edx
80104989:	29 c2                	sub    %eax,%edx
8010498b:	83 e2 04             	and    $0x4,%edx
8010498e:	74 10                	je     801049a0 <acquire+0xb0>
    pcs[i] = 0;
80104990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104996:	83 c0 04             	add    $0x4,%eax
80104999:	39 c1                	cmp    %eax,%ecx
8010499b:	74 da                	je     80104977 <acquire+0x87>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801049a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049a6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801049a9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801049b0:	39 c1                	cmp    %eax,%ecx
801049b2:	75 ec                	jne    801049a0 <acquire+0xb0>
801049b4:	eb c1                	jmp    80104977 <acquire+0x87>
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049c0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801049c3:	e8 18 ef ff ff       	call   801038e0 <mycpu>
801049c8:	39 c3                	cmp    %eax,%ebx
801049ca:	0f 85 3e ff ff ff    	jne    8010490e <acquire+0x1e>
  popcli();
801049d0:	e8 1b fe ff ff       	call   801047f0 <popcli>
    panic("acquire");
801049d5:	83 ec 0c             	sub    $0xc,%esp
801049d8:	68 a9 89 10 80       	push   $0x801089a9
801049dd:	e8 9e b9 ff ff       	call   80100380 <panic>
801049e2:	66 90                	xchg   %ax,%ax
801049e4:	66 90                	xchg   %ax,%ax
801049e6:	66 90                	xchg   %ax,%ax
801049e8:	66 90                	xchg   %ax,%ax
801049ea:	66 90                	xchg   %ax,%ax
801049ec:	66 90                	xchg   %ax,%ax
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	8b 55 08             	mov    0x8(%ebp),%edx
801049f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049fa:	89 d0                	mov    %edx,%eax
801049fc:	09 c8                	or     %ecx,%eax
801049fe:	a8 03                	test   $0x3,%al
80104a00:	75 1e                	jne    80104a20 <memset+0x30>
    c &= 0xFF;
80104a02:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a06:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104a09:	89 d7                	mov    %edx,%edi
80104a0b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104a11:	fc                   	cld
80104a12:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a14:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104a17:	89 d0                	mov    %edx,%eax
80104a19:	c9                   	leave
80104a1a:	c3                   	ret
80104a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a1f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104a20:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a23:	89 d7                	mov    %edx,%edi
80104a25:	fc                   	cld
80104a26:	f3 aa                	rep stos %al,%es:(%edi)
80104a28:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104a2b:	89 d0                	mov    %edx,%eax
80104a2d:	c9                   	leave
80104a2e:	c3                   	ret
80104a2f:	90                   	nop

80104a30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	8b 75 10             	mov    0x10(%ebp),%esi
80104a37:	8b 45 08             	mov    0x8(%ebp),%eax
80104a3a:	53                   	push   %ebx
80104a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a3e:	85 f6                	test   %esi,%esi
80104a40:	74 2e                	je     80104a70 <memcmp+0x40>
80104a42:	01 c6                	add    %eax,%esi
80104a44:	eb 14                	jmp    80104a5a <memcmp+0x2a>
80104a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a50:	83 c0 01             	add    $0x1,%eax
80104a53:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a56:	39 f0                	cmp    %esi,%eax
80104a58:	74 16                	je     80104a70 <memcmp+0x40>
    if(*s1 != *s2)
80104a5a:	0f b6 08             	movzbl (%eax),%ecx
80104a5d:	0f b6 1a             	movzbl (%edx),%ebx
80104a60:	38 d9                	cmp    %bl,%cl
80104a62:	74 ec                	je     80104a50 <memcmp+0x20>
      return *s1 - *s2;
80104a64:	0f b6 c1             	movzbl %cl,%eax
80104a67:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	5b                   	pop    %ebx
  return 0;
80104a71:	31 c0                	xor    %eax,%eax
}
80104a73:	5e                   	pop    %esi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret
80104a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi

80104a80 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	57                   	push   %edi
80104a84:	8b 55 08             	mov    0x8(%ebp),%edx
80104a87:	8b 45 10             	mov    0x10(%ebp),%eax
80104a8a:	56                   	push   %esi
80104a8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a8e:	39 d6                	cmp    %edx,%esi
80104a90:	73 26                	jae    80104ab8 <memmove+0x38>
80104a92:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a95:	39 ca                	cmp    %ecx,%edx
80104a97:	73 1f                	jae    80104ab8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a99:	85 c0                	test   %eax,%eax
80104a9b:	74 0f                	je     80104aac <memmove+0x2c>
80104a9d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104aa0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104aa4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104aa7:	83 e8 01             	sub    $0x1,%eax
80104aaa:	73 f4                	jae    80104aa0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104aac:	5e                   	pop    %esi
80104aad:	89 d0                	mov    %edx,%eax
80104aaf:	5f                   	pop    %edi
80104ab0:	5d                   	pop    %ebp
80104ab1:	c3                   	ret
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ab8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104abb:	89 d7                	mov    %edx,%edi
80104abd:	85 c0                	test   %eax,%eax
80104abf:	74 eb                	je     80104aac <memmove+0x2c>
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ac8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ac9:	39 ce                	cmp    %ecx,%esi
80104acb:	75 fb                	jne    80104ac8 <memmove+0x48>
}
80104acd:	5e                   	pop    %esi
80104ace:	89 d0                	mov    %edx,%eax
80104ad0:	5f                   	pop    %edi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret
80104ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ae0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ae0:	eb 9e                	jmp    80104a80 <memmove>
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104af0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	8b 55 10             	mov    0x10(%ebp),%edx
80104af7:	8b 45 08             	mov    0x8(%ebp),%eax
80104afa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104afd:	85 d2                	test   %edx,%edx
80104aff:	75 16                	jne    80104b17 <strncmp+0x27>
80104b01:	eb 2d                	jmp    80104b30 <strncmp+0x40>
80104b03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b07:	90                   	nop
80104b08:	3a 19                	cmp    (%ecx),%bl
80104b0a:	75 12                	jne    80104b1e <strncmp+0x2e>
    n--, p++, q++;
80104b0c:	83 c0 01             	add    $0x1,%eax
80104b0f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b12:	83 ea 01             	sub    $0x1,%edx
80104b15:	74 19                	je     80104b30 <strncmp+0x40>
80104b17:	0f b6 18             	movzbl (%eax),%ebx
80104b1a:	84 db                	test   %bl,%bl
80104b1c:	75 ea                	jne    80104b08 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b1e:	0f b6 00             	movzbl (%eax),%eax
80104b21:	0f b6 11             	movzbl (%ecx),%edx
}
80104b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b27:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104b28:	29 d0                	sub    %edx,%eax
}
80104b2a:	c3                   	ret
80104b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop
80104b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104b33:	31 c0                	xor    %eax,%eax
}
80104b35:	c9                   	leave
80104b36:	c3                   	ret
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	8b 75 08             	mov    0x8(%ebp),%esi
80104b48:	53                   	push   %ebx
80104b49:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b4c:	89 f0                	mov    %esi,%eax
80104b4e:	eb 15                	jmp    80104b65 <strncpy+0x25>
80104b50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b54:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b57:	83 c0 01             	add    $0x1,%eax
80104b5a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104b5e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104b61:	84 c9                	test   %cl,%cl
80104b63:	74 13                	je     80104b78 <strncpy+0x38>
80104b65:	89 d3                	mov    %edx,%ebx
80104b67:	83 ea 01             	sub    $0x1,%edx
80104b6a:	85 db                	test   %ebx,%ebx
80104b6c:	7f e2                	jg     80104b50 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	89 f0                	mov    %esi,%eax
80104b71:	5e                   	pop    %esi
80104b72:	5f                   	pop    %edi
80104b73:	5d                   	pop    %ebp
80104b74:	c3                   	ret
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104b78:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104b7b:	83 e9 01             	sub    $0x1,%ecx
80104b7e:	85 d2                	test   %edx,%edx
80104b80:	74 ec                	je     80104b6e <strncpy+0x2e>
80104b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104b88:	83 c0 01             	add    $0x1,%eax
80104b8b:	89 ca                	mov    %ecx,%edx
80104b8d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104b91:	29 c2                	sub    %eax,%edx
80104b93:	85 d2                	test   %edx,%edx
80104b95:	7f f1                	jg     80104b88 <strncpy+0x48>
}
80104b97:	5b                   	pop    %ebx
80104b98:	89 f0                	mov    %esi,%eax
80104b9a:	5e                   	pop    %esi
80104b9b:	5f                   	pop    %edi
80104b9c:	5d                   	pop    %ebp
80104b9d:	c3                   	ret
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ba7:	8b 75 08             	mov    0x8(%ebp),%esi
80104baa:	53                   	push   %ebx
80104bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104bae:	85 d2                	test   %edx,%edx
80104bb0:	7e 25                	jle    80104bd7 <safestrcpy+0x37>
80104bb2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104bb6:	89 f2                	mov    %esi,%edx
80104bb8:	eb 16                	jmp    80104bd0 <safestrcpy+0x30>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104bc0:	0f b6 08             	movzbl (%eax),%ecx
80104bc3:	83 c0 01             	add    $0x1,%eax
80104bc6:	83 c2 01             	add    $0x1,%edx
80104bc9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bcc:	84 c9                	test   %cl,%cl
80104bce:	74 04                	je     80104bd4 <safestrcpy+0x34>
80104bd0:	39 d8                	cmp    %ebx,%eax
80104bd2:	75 ec                	jne    80104bc0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bd4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104bd7:	89 f0                	mov    %esi,%eax
80104bd9:	5b                   	pop    %ebx
80104bda:	5e                   	pop    %esi
80104bdb:	5d                   	pop    %ebp
80104bdc:	c3                   	ret
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi

80104be0 <strlen>:

int
strlen(const char *s)
{
80104be0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104be8:	80 3a 00             	cmpb   $0x0,(%edx)
80104beb:	74 0c                	je     80104bf9 <strlen+0x19>
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
80104bf0:	83 c0 01             	add    $0x1,%eax
80104bf3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bf7:	75 f7                	jne    80104bf0 <strlen+0x10>
    ;
  return n;
}
80104bf9:	5d                   	pop    %ebp
80104bfa:	c3                   	ret

80104bfb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bfb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c03:	55                   	push   %ebp
  pushl %ebx
80104c04:	53                   	push   %ebx
  pushl %esi
80104c05:	56                   	push   %esi
  pushl %edi
80104c06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c09:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c0b:	5f                   	pop    %edi
  popl %esi
80104c0c:	5e                   	pop    %esi
  popl %ebx
80104c0d:	5b                   	pop    %ebx
  popl %ebp
80104c0e:	5d                   	pop    %ebp
  ret
80104c0f:	c3                   	ret

80104c10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c1a:	e8 41 ed ff ff       	call   80103960 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c1f:	8b 00                	mov    (%eax),%eax
80104c21:	39 c3                	cmp    %eax,%ebx
80104c23:	73 1b                	jae    80104c40 <fetchint+0x30>
80104c25:	8d 53 04             	lea    0x4(%ebx),%edx
80104c28:	39 d0                	cmp    %edx,%eax
80104c2a:	72 14                	jb     80104c40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c2f:	8b 13                	mov    (%ebx),%edx
80104c31:	89 10                	mov    %edx,(%eax)
  return 0;
80104c33:	31 c0                	xor    %eax,%eax
}
80104c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c38:	c9                   	leave
80104c39:	c3                   	ret
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c45:	eb ee                	jmp    80104c35 <fetchint+0x25>
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
80104c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c5a:	e8 01 ed ff ff       	call   80103960 <myproc>

  if(addr >= curproc->sz)
80104c5f:	3b 18                	cmp    (%eax),%ebx
80104c61:	73 2d                	jae    80104c90 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c63:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c66:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c68:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c6a:	39 d3                	cmp    %edx,%ebx
80104c6c:	73 22                	jae    80104c90 <fetchstr+0x40>
80104c6e:	89 d8                	mov    %ebx,%eax
80104c70:	eb 0d                	jmp    80104c7f <fetchstr+0x2f>
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c78:	83 c0 01             	add    $0x1,%eax
80104c7b:	39 d0                	cmp    %edx,%eax
80104c7d:	73 11                	jae    80104c90 <fetchstr+0x40>
    if(*s == 0)
80104c7f:	80 38 00             	cmpb   $0x0,(%eax)
80104c82:	75 f4                	jne    80104c78 <fetchstr+0x28>
      return s - *pp;
80104c84:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c89:	c9                   	leave
80104c8a:	c3                   	ret
80104c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop
80104c90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c98:	c9                   	leave
80104c99:	c3                   	ret
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ca0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ca5:	e8 b6 ec ff ff       	call   80103960 <myproc>
80104caa:	8b 55 08             	mov    0x8(%ebp),%edx
80104cad:	8b 40 18             	mov    0x18(%eax),%eax
80104cb0:	8b 40 44             	mov    0x44(%eax),%eax
80104cb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cb6:	e8 a5 ec ff ff       	call   80103960 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cbe:	8b 00                	mov    (%eax),%eax
80104cc0:	39 c6                	cmp    %eax,%esi
80104cc2:	73 1c                	jae    80104ce0 <argint+0x40>
80104cc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cc7:	39 d0                	cmp    %edx,%eax
80104cc9:	72 15                	jb     80104ce0 <argint+0x40>
  *ip = *(int*)(addr);
80104ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cce:	8b 53 04             	mov    0x4(%ebx),%edx
80104cd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cd3:	31 c0                	xor    %eax,%eax
}
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	eb ee                	jmp    80104cd5 <argint+0x35>
80104ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104cf9:	e8 62 ec ff ff       	call   80103960 <myproc>
80104cfe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d00:	e8 5b ec ff ff       	call   80103960 <myproc>
80104d05:	8b 55 08             	mov    0x8(%ebp),%edx
80104d08:	8b 40 18             	mov    0x18(%eax),%eax
80104d0b:	8b 40 44             	mov    0x44(%eax),%eax
80104d0e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d11:	e8 4a ec ff ff       	call   80103960 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d16:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d19:	8b 00                	mov    (%eax),%eax
80104d1b:	39 c7                	cmp    %eax,%edi
80104d1d:	73 31                	jae    80104d50 <argptr+0x60>
80104d1f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d22:	39 c8                	cmp    %ecx,%eax
80104d24:	72 2a                	jb     80104d50 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d26:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d29:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d2c:	85 d2                	test   %edx,%edx
80104d2e:	78 20                	js     80104d50 <argptr+0x60>
80104d30:	8b 16                	mov    (%esi),%edx
80104d32:	39 d0                	cmp    %edx,%eax
80104d34:	73 1a                	jae    80104d50 <argptr+0x60>
80104d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d39:	01 c3                	add    %eax,%ebx
80104d3b:	39 da                	cmp    %ebx,%edx
80104d3d:	72 11                	jb     80104d50 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d42:	89 02                	mov    %eax,(%edx)
  return 0;
80104d44:	31 c0                	xor    %eax,%eax
}
80104d46:	83 c4 0c             	add    $0xc,%esp
80104d49:	5b                   	pop    %ebx
80104d4a:	5e                   	pop    %esi
80104d4b:	5f                   	pop    %edi
80104d4c:	5d                   	pop    %ebp
80104d4d:	c3                   	ret
80104d4e:	66 90                	xchg   %ax,%ax
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d55:	eb ef                	jmp    80104d46 <argptr+0x56>
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d65:	e8 f6 eb ff ff       	call   80103960 <myproc>
80104d6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d6d:	8b 40 18             	mov    0x18(%eax),%eax
80104d70:	8b 40 44             	mov    0x44(%eax),%eax
80104d73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d76:	e8 e5 eb ff ff       	call   80103960 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d7e:	8b 00                	mov    (%eax),%eax
80104d80:	39 c6                	cmp    %eax,%esi
80104d82:	73 44                	jae    80104dc8 <argstr+0x68>
80104d84:	8d 53 08             	lea    0x8(%ebx),%edx
80104d87:	39 d0                	cmp    %edx,%eax
80104d89:	72 3d                	jb     80104dc8 <argstr+0x68>
  *ip = *(int*)(addr);
80104d8b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d8e:	e8 cd eb ff ff       	call   80103960 <myproc>
  if(addr >= curproc->sz)
80104d93:	3b 18                	cmp    (%eax),%ebx
80104d95:	73 31                	jae    80104dc8 <argstr+0x68>
  *pp = (char*)addr;
80104d97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d9e:	39 d3                	cmp    %edx,%ebx
80104da0:	73 26                	jae    80104dc8 <argstr+0x68>
80104da2:	89 d8                	mov    %ebx,%eax
80104da4:	eb 11                	jmp    80104db7 <argstr+0x57>
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
80104db0:	83 c0 01             	add    $0x1,%eax
80104db3:	39 d0                	cmp    %edx,%eax
80104db5:	73 11                	jae    80104dc8 <argstr+0x68>
    if(*s == 0)
80104db7:	80 38 00             	cmpb   $0x0,(%eax)
80104dba:	75 f4                	jne    80104db0 <argstr+0x50>
      return s - *pp;
80104dbc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104dbe:	5b                   	pop    %ebx
80104dbf:	5e                   	pop    %esi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dc8:	5b                   	pop    %ebx
    return -1;
80104dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dce:	5e                   	pop    %esi
80104dcf:	5d                   	pop    %ebp
80104dd0:	c3                   	ret
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop

80104de0 <syscall>:
[SYS_getpgdirinfo]    sys_getpgdirinfo,
};

void
syscall(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104de7:	e8 74 eb ff ff       	call   80103960 <myproc>
80104dec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dee:	8b 40 18             	mov    0x18(%eax),%eax
80104df1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104df4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104df7:	83 fa 19             	cmp    $0x19,%edx
80104dfa:	77 24                	ja     80104e20 <syscall+0x40>
80104dfc:	8b 14 85 00 90 10 80 	mov    -0x7fef7000(,%eax,4),%edx
80104e03:	85 d2                	test   %edx,%edx
80104e05:	74 19                	je     80104e20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104e07:	ff d2                	call   *%edx
80104e09:	89 c2                	mov    %eax,%edx
80104e0b:	8b 43 18             	mov    0x18(%ebx),%eax
80104e0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e14:	c9                   	leave
80104e15:	c3                   	ret
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e24:	50                   	push   %eax
80104e25:	ff 73 10             	push   0x10(%ebx)
80104e28:	68 b1 89 10 80       	push   $0x801089b1
80104e2d:	e8 7e b8 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104e32:	8b 43 18             	mov    0x18(%ebx),%eax
80104e35:	83 c4 10             	add    $0x10,%esp
80104e38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e42:	c9                   	leave
80104e43:	c3                   	ret
80104e44:	66 90                	xchg   %ax,%ax
80104e46:	66 90                	xchg   %ax,%ax
80104e48:	66 90                	xchg   %ax,%ax
80104e4a:	66 90                	xchg   %ax,%ax
80104e4c:	66 90                	xchg   %ax,%ax
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e58:	53                   	push   %ebx
80104e59:	83 ec 34             	sub    $0x34,%esp
80104e5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e62:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e65:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e68:	57                   	push   %edi
80104e69:	50                   	push   %eax
80104e6a:	e8 31 d2 ff ff       	call   801020a0 <nameiparent>
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	85 c0                	test   %eax,%eax
80104e74:	74 5e                	je     80104ed4 <create+0x84>
    return 0;
  ilock(dp);
80104e76:	83 ec 0c             	sub    $0xc,%esp
80104e79:	89 c3                	mov    %eax,%ebx
80104e7b:	50                   	push   %eax
80104e7c:	e8 1f c9 ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e81:	83 c4 0c             	add    $0xc,%esp
80104e84:	6a 00                	push   $0x0
80104e86:	57                   	push   %edi
80104e87:	53                   	push   %ebx
80104e88:	e8 63 ce ff ff       	call   80101cf0 <dirlookup>
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	89 c6                	mov    %eax,%esi
80104e92:	85 c0                	test   %eax,%eax
80104e94:	74 4a                	je     80104ee0 <create+0x90>
    iunlockput(dp);
80104e96:	83 ec 0c             	sub    $0xc,%esp
80104e99:	53                   	push   %ebx
80104e9a:	e8 91 cb ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104e9f:	89 34 24             	mov    %esi,(%esp)
80104ea2:	e8 f9 c8 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104eaf:	75 17                	jne    80104ec8 <create+0x78>
80104eb1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104eb6:	75 10                	jne    80104ec8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ebb:	89 f0                	mov    %esi,%eax
80104ebd:	5b                   	pop    %ebx
80104ebe:	5e                   	pop    %esi
80104ebf:	5f                   	pop    %edi
80104ec0:	5d                   	pop    %ebp
80104ec1:	c3                   	ret
80104ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	56                   	push   %esi
80104ecc:	e8 5f cb ff ff       	call   80101a30 <iunlockput>
    return 0;
80104ed1:	83 c4 10             	add    $0x10,%esp
}
80104ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ed7:	31 f6                	xor    %esi,%esi
}
80104ed9:	5b                   	pop    %ebx
80104eda:	89 f0                	mov    %esi,%eax
80104edc:	5e                   	pop    %esi
80104edd:	5f                   	pop    %edi
80104ede:	5d                   	pop    %ebp
80104edf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104ee0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ee4:	83 ec 08             	sub    $0x8,%esp
80104ee7:	50                   	push   %eax
80104ee8:	ff 33                	push   (%ebx)
80104eea:	e8 41 c7 ff ff       	call   80101630 <ialloc>
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	89 c6                	mov    %eax,%esi
80104ef4:	85 c0                	test   %eax,%eax
80104ef6:	0f 84 bc 00 00 00    	je     80104fb8 <create+0x168>
  ilock(ip);
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	50                   	push   %eax
80104f00:	e8 9b c8 ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104f05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f15:	b8 01 00 00 00       	mov    $0x1,%eax
80104f1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f1e:	89 34 24             	mov    %esi,(%esp)
80104f21:	e8 ca c7 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f26:	83 c4 10             	add    $0x10,%esp
80104f29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f2e:	74 30                	je     80104f60 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104f30:	83 ec 04             	sub    $0x4,%esp
80104f33:	ff 76 04             	push   0x4(%esi)
80104f36:	57                   	push   %edi
80104f37:	53                   	push   %ebx
80104f38:	e8 83 d0 ff ff       	call   80101fc0 <dirlink>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	78 67                	js     80104fab <create+0x15b>
  iunlockput(dp);
80104f44:	83 ec 0c             	sub    $0xc,%esp
80104f47:	53                   	push   %ebx
80104f48:	e8 e3 ca ff ff       	call   80101a30 <iunlockput>
  return ip;
80104f4d:	83 c4 10             	add    $0x10,%esp
}
80104f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f53:	89 f0                	mov    %esi,%eax
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5f                   	pop    %edi
80104f58:	5d                   	pop    %ebp
80104f59:	c3                   	ret
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f68:	53                   	push   %ebx
80104f69:	e8 82 c7 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f6e:	83 c4 0c             	add    $0xc,%esp
80104f71:	ff 76 04             	push   0x4(%esi)
80104f74:	68 e9 89 10 80       	push   $0x801089e9
80104f79:	56                   	push   %esi
80104f7a:	e8 41 d0 ff ff       	call   80101fc0 <dirlink>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 18                	js     80104f9e <create+0x14e>
80104f86:	83 ec 04             	sub    $0x4,%esp
80104f89:	ff 73 04             	push   0x4(%ebx)
80104f8c:	68 e8 89 10 80       	push   $0x801089e8
80104f91:	56                   	push   %esi
80104f92:	e8 29 d0 ff ff       	call   80101fc0 <dirlink>
80104f97:	83 c4 10             	add    $0x10,%esp
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	79 92                	jns    80104f30 <create+0xe0>
      panic("create dots");
80104f9e:	83 ec 0c             	sub    $0xc,%esp
80104fa1:	68 dc 89 10 80       	push   $0x801089dc
80104fa6:	e8 d5 b3 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104fab:	83 ec 0c             	sub    $0xc,%esp
80104fae:	68 eb 89 10 80       	push   $0x801089eb
80104fb3:	e8 c8 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104fb8:	83 ec 0c             	sub    $0xc,%esp
80104fbb:	68 cd 89 10 80       	push   $0x801089cd
80104fc0:	e8 bb b3 ff ff       	call   80100380 <panic>
80104fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <argfd>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fd8:	83 ec 18             	sub    $0x18,%esp
80104fdb:	8b 75 0c             	mov    0xc(%ebp),%esi
80104fde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(argint(n, &fd) < 0)
80104fe1:	50                   	push   %eax
80104fe2:	ff 75 08             	push   0x8(%ebp)
80104fe5:	e8 b6 fc ff ff       	call   80104ca0 <argint>
80104fea:	83 c4 10             	add    $0x10,%esp
80104fed:	85 c0                	test   %eax,%eax
80104fef:	78 2f                	js     80105020 <argfd+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ff1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ff5:	77 29                	ja     80105020 <argfd+0x50>
80104ff7:	e8 64 e9 ff ff       	call   80103960 <myproc>
80104ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fff:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105003:	85 c0                	test   %eax,%eax
80105005:	74 19                	je     80105020 <argfd+0x50>
  if(pfd)
80105007:	85 f6                	test   %esi,%esi
80105009:	74 02                	je     8010500d <argfd+0x3d>
    *pfd = fd;
8010500b:	89 16                	mov    %edx,(%esi)
  if(pf)
8010500d:	85 db                	test   %ebx,%ebx
8010500f:	74 02                	je     80105013 <argfd+0x43>
    *pf = f;
80105011:	89 03                	mov    %eax,(%ebx)
  return 0;
80105013:	31 c0                	xor    %eax,%eax
}
80105015:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105018:	5b                   	pop    %ebx
80105019:	5e                   	pop    %esi
8010501a:	5d                   	pop    %ebp
8010501b:	c3                   	ret
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	eb ee                	jmp    80105015 <argfd+0x45>
80105027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502e:	66 90                	xchg   %ax,%ax

80105030 <sys_dup>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	50                   	push   %eax
8010503c:	6a 00                	push   $0x0
8010503e:	e8 5d fc ff ff       	call   80104ca0 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 36                	js     80105080 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 30                	ja     80105080 <sys_dup+0x50>
80105050:	e8 0b e9 ff ff       	call   80103960 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010505c:	85 f6                	test   %esi,%esi
8010505e:	74 20                	je     80105080 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105060:	e8 fb e8 ff ff       	call   80103960 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105065:	31 db                	xor    %ebx,%ebx
80105067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105070:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105074:	85 d2                	test   %edx,%edx
80105076:	74 18                	je     80105090 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105078:	83 c3 01             	add    $0x1,%ebx
8010507b:	83 fb 10             	cmp    $0x10,%ebx
8010507e:	75 f0                	jne    80105070 <sys_dup+0x40>
}
80105080:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105083:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105088:	89 d8                	mov    %ebx,%eax
8010508a:	5b                   	pop    %ebx
8010508b:	5e                   	pop    %esi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret
8010508e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105090:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105093:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105097:	56                   	push   %esi
80105098:	e8 23 be ff ff       	call   80100ec0 <filedup>
  return fd;
8010509d:	83 c4 10             	add    $0x10,%esp
}
801050a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a3:	89 d8                	mov    %ebx,%eax
801050a5:	5b                   	pop    %ebx
801050a6:	5e                   	pop    %esi
801050a7:	5d                   	pop    %ebp
801050a8:	c3                   	ret
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050b0 <sys_read>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050bb:	53                   	push   %ebx
801050bc:	6a 00                	push   $0x0
801050be:	e8 dd fb ff ff       	call   80104ca0 <argint>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 5e                	js     80105128 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ce:	77 58                	ja     80105128 <sys_read+0x78>
801050d0:	e8 8b e8 ff ff       	call   80103960 <myproc>
801050d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050dc:	85 f6                	test   %esi,%esi
801050de:	74 48                	je     80105128 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050e0:	83 ec 08             	sub    $0x8,%esp
801050e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050e6:	50                   	push   %eax
801050e7:	6a 02                	push   $0x2
801050e9:	e8 b2 fb ff ff       	call   80104ca0 <argint>
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	85 c0                	test   %eax,%eax
801050f3:	78 33                	js     80105128 <sys_read+0x78>
801050f5:	83 ec 04             	sub    $0x4,%esp
801050f8:	ff 75 f0             	push   -0x10(%ebp)
801050fb:	53                   	push   %ebx
801050fc:	6a 01                	push   $0x1
801050fe:	e8 ed fb ff ff       	call   80104cf0 <argptr>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	78 1e                	js     80105128 <sys_read+0x78>
  return fileread(f, p, n);
8010510a:	83 ec 04             	sub    $0x4,%esp
8010510d:	ff 75 f0             	push   -0x10(%ebp)
80105110:	ff 75 f4             	push   -0xc(%ebp)
80105113:	56                   	push   %esi
80105114:	e8 27 bf ff ff       	call   80101040 <fileread>
80105119:	83 c4 10             	add    $0x10,%esp
}
8010511c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010511f:	5b                   	pop    %ebx
80105120:	5e                   	pop    %esi
80105121:	5d                   	pop    %ebp
80105122:	c3                   	ret
80105123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105127:	90                   	nop
    return -1;
80105128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512d:	eb ed                	jmp    8010511c <sys_read+0x6c>
8010512f:	90                   	nop

80105130 <sys_write>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105135:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105138:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010513b:	53                   	push   %ebx
8010513c:	6a 00                	push   $0x0
8010513e:	e8 5d fb ff ff       	call   80104ca0 <argint>
80105143:	83 c4 10             	add    $0x10,%esp
80105146:	85 c0                	test   %eax,%eax
80105148:	78 5e                	js     801051a8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010514a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010514e:	77 58                	ja     801051a8 <sys_write+0x78>
80105150:	e8 0b e8 ff ff       	call   80103960 <myproc>
80105155:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105158:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010515c:	85 f6                	test   %esi,%esi
8010515e:	74 48                	je     801051a8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105160:	83 ec 08             	sub    $0x8,%esp
80105163:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105166:	50                   	push   %eax
80105167:	6a 02                	push   $0x2
80105169:	e8 32 fb ff ff       	call   80104ca0 <argint>
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	85 c0                	test   %eax,%eax
80105173:	78 33                	js     801051a8 <sys_write+0x78>
80105175:	83 ec 04             	sub    $0x4,%esp
80105178:	ff 75 f0             	push   -0x10(%ebp)
8010517b:	53                   	push   %ebx
8010517c:	6a 01                	push   $0x1
8010517e:	e8 6d fb ff ff       	call   80104cf0 <argptr>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 1e                	js     801051a8 <sys_write+0x78>
  return filewrite(f, p, n);
8010518a:	83 ec 04             	sub    $0x4,%esp
8010518d:	ff 75 f0             	push   -0x10(%ebp)
80105190:	ff 75 f4             	push   -0xc(%ebp)
80105193:	56                   	push   %esi
80105194:	e8 37 bf ff ff       	call   801010d0 <filewrite>
80105199:	83 c4 10             	add    $0x10,%esp
}
8010519c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010519f:	5b                   	pop    %ebx
801051a0:	5e                   	pop    %esi
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret
801051a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051a7:	90                   	nop
    return -1;
801051a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ad:	eb ed                	jmp    8010519c <sys_write+0x6c>
801051af:	90                   	nop

801051b0 <sys_close>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051bb:	50                   	push   %eax
801051bc:	6a 00                	push   $0x0
801051be:	e8 dd fa ff ff       	call   80104ca0 <argint>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	78 3e                	js     80105208 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051ce:	77 38                	ja     80105208 <sys_close+0x58>
801051d0:	e8 8b e7 ff ff       	call   80103960 <myproc>
801051d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051d8:	8d 5a 08             	lea    0x8(%edx),%ebx
801051db:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801051df:	85 f6                	test   %esi,%esi
801051e1:	74 25                	je     80105208 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801051e3:	e8 78 e7 ff ff       	call   80103960 <myproc>
  fileclose(f);
801051e8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051eb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801051f2:	00 
  fileclose(f);
801051f3:	56                   	push   %esi
801051f4:	e8 17 bd ff ff       	call   80100f10 <fileclose>
  return 0;
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	31 c0                	xor    %eax,%eax
}
801051fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105201:	5b                   	pop    %ebx
80105202:	5e                   	pop    %esi
80105203:	5d                   	pop    %ebp
80105204:	c3                   	ret
80105205:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520d:	eb ef                	jmp    801051fe <sys_close+0x4e>
8010520f:	90                   	nop

80105210 <sys_fstat>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105215:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105218:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010521b:	53                   	push   %ebx
8010521c:	6a 00                	push   $0x0
8010521e:	e8 7d fa ff ff       	call   80104ca0 <argint>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 46                	js     80105270 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010522a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010522e:	77 40                	ja     80105270 <sys_fstat+0x60>
80105230:	e8 2b e7 ff ff       	call   80103960 <myproc>
80105235:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105238:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010523c:	85 f6                	test   %esi,%esi
8010523e:	74 30                	je     80105270 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105240:	83 ec 04             	sub    $0x4,%esp
80105243:	6a 14                	push   $0x14
80105245:	53                   	push   %ebx
80105246:	6a 01                	push   $0x1
80105248:	e8 a3 fa ff ff       	call   80104cf0 <argptr>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	78 1c                	js     80105270 <sys_fstat+0x60>
  return filestat(f, st);
80105254:	83 ec 08             	sub    $0x8,%esp
80105257:	ff 75 f4             	push   -0xc(%ebp)
8010525a:	56                   	push   %esi
8010525b:	e8 90 bd ff ff       	call   80100ff0 <filestat>
80105260:	83 c4 10             	add    $0x10,%esp
}
80105263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105266:	5b                   	pop    %ebx
80105267:	5e                   	pop    %esi
80105268:	5d                   	pop    %ebp
80105269:	c3                   	ret
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb ec                	jmp    80105263 <sys_fstat+0x53>
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <sys_link>:
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105285:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105288:	53                   	push   %ebx
80105289:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010528c:	50                   	push   %eax
8010528d:	6a 00                	push   $0x0
8010528f:	e8 cc fa ff ff       	call   80104d60 <argstr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	0f 88 fb 00 00 00    	js     8010539a <sys_link+0x11a>
8010529f:	83 ec 08             	sub    $0x8,%esp
801052a2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052a5:	50                   	push   %eax
801052a6:	6a 01                	push   $0x1
801052a8:	e8 b3 fa ff ff       	call   80104d60 <argstr>
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	85 c0                	test   %eax,%eax
801052b2:	0f 88 e2 00 00 00    	js     8010539a <sys_link+0x11a>
  begin_op();
801052b8:	e8 83 da ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	ff 75 d4             	push   -0x2c(%ebp)
801052c3:	e8 b8 cd ff ff       	call   80102080 <namei>
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	89 c3                	mov    %eax,%ebx
801052cd:	85 c0                	test   %eax,%eax
801052cf:	0f 84 df 00 00 00    	je     801053b4 <sys_link+0x134>
  ilock(ip);
801052d5:	83 ec 0c             	sub    $0xc,%esp
801052d8:	50                   	push   %eax
801052d9:	e8 c2 c4 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	0f 84 b5 00 00 00    	je     801053a1 <sys_link+0x121>
  iupdate(ip);
801052ec:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052ef:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801052f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052f7:	53                   	push   %ebx
801052f8:	e8 f3 c3 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801052fd:	89 1c 24             	mov    %ebx,(%esp)
80105300:	e8 7b c5 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105305:	58                   	pop    %eax
80105306:	5a                   	pop    %edx
80105307:	57                   	push   %edi
80105308:	ff 75 d0             	push   -0x30(%ebp)
8010530b:	e8 90 cd ff ff       	call   801020a0 <nameiparent>
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	89 c6                	mov    %eax,%esi
80105315:	85 c0                	test   %eax,%eax
80105317:	74 5b                	je     80105374 <sys_link+0xf4>
  ilock(dp);
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	50                   	push   %eax
8010531d:	e8 7e c4 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105322:	8b 03                	mov    (%ebx),%eax
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	39 06                	cmp    %eax,(%esi)
80105329:	75 3d                	jne    80105368 <sys_link+0xe8>
8010532b:	83 ec 04             	sub    $0x4,%esp
8010532e:	ff 73 04             	push   0x4(%ebx)
80105331:	57                   	push   %edi
80105332:	56                   	push   %esi
80105333:	e8 88 cc ff ff       	call   80101fc0 <dirlink>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	85 c0                	test   %eax,%eax
8010533d:	78 29                	js     80105368 <sys_link+0xe8>
  iunlockput(dp);
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	56                   	push   %esi
80105343:	e8 e8 c6 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105348:	89 1c 24             	mov    %ebx,(%esp)
8010534b:	e8 80 c5 ff ff       	call   801018d0 <iput>
  end_op();
80105350:	e8 5b da ff ff       	call   80102db0 <end_op>
  return 0;
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	31 c0                	xor    %eax,%eax
}
8010535a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010535d:	5b                   	pop    %ebx
8010535e:	5e                   	pop    %esi
8010535f:	5f                   	pop    %edi
80105360:	5d                   	pop    %ebp
80105361:	c3                   	ret
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105368:	83 ec 0c             	sub    $0xc,%esp
8010536b:	56                   	push   %esi
8010536c:	e8 bf c6 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105371:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	53                   	push   %ebx
80105378:	e8 23 c4 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010537d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105382:	89 1c 24             	mov    %ebx,(%esp)
80105385:	e8 66 c3 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010538a:	89 1c 24             	mov    %ebx,(%esp)
8010538d:	e8 9e c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105392:	e8 19 da ff ff       	call   80102db0 <end_op>
  return -1;
80105397:	83 c4 10             	add    $0x10,%esp
    return -1;
8010539a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539f:	eb b9                	jmp    8010535a <sys_link+0xda>
    iunlockput(ip);
801053a1:	83 ec 0c             	sub    $0xc,%esp
801053a4:	53                   	push   %ebx
801053a5:	e8 86 c6 ff ff       	call   80101a30 <iunlockput>
    end_op();
801053aa:	e8 01 da ff ff       	call   80102db0 <end_op>
    return -1;
801053af:	83 c4 10             	add    $0x10,%esp
801053b2:	eb e6                	jmp    8010539a <sys_link+0x11a>
    end_op();
801053b4:	e8 f7 d9 ff ff       	call   80102db0 <end_op>
    return -1;
801053b9:	eb df                	jmp    8010539a <sys_link+0x11a>
801053bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop

801053c0 <sys_unlink>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053c8:	53                   	push   %ebx
801053c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 8c f9 ff ff       	call   80104d60 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 54 01 00 00    	js     80105533 <sys_unlink+0x173>
  begin_op();
801053df:	e8 5c d9 ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053e7:	83 ec 08             	sub    $0x8,%esp
801053ea:	53                   	push   %ebx
801053eb:	ff 75 c0             	push   -0x40(%ebp)
801053ee:	e8 ad cc ff ff       	call   801020a0 <nameiparent>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053f9:	85 c0                	test   %eax,%eax
801053fb:	0f 84 58 01 00 00    	je     80105559 <sys_unlink+0x199>
  ilock(dp);
80105401:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	57                   	push   %edi
80105408:	e8 93 c3 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010540d:	58                   	pop    %eax
8010540e:	5a                   	pop    %edx
8010540f:	68 e9 89 10 80       	push   $0x801089e9
80105414:	53                   	push   %ebx
80105415:	e8 b6 c8 ff ff       	call   80101cd0 <namecmp>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	0f 84 fb 00 00 00    	je     80105520 <sys_unlink+0x160>
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	68 e8 89 10 80       	push   $0x801089e8
8010542d:	53                   	push   %ebx
8010542e:	e8 9d c8 ff ff       	call   80101cd0 <namecmp>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	0f 84 e2 00 00 00    	je     80105520 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010543e:	83 ec 04             	sub    $0x4,%esp
80105441:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105444:	50                   	push   %eax
80105445:	53                   	push   %ebx
80105446:	57                   	push   %edi
80105447:	e8 a4 c8 ff ff       	call   80101cf0 <dirlookup>
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	89 c3                	mov    %eax,%ebx
80105451:	85 c0                	test   %eax,%eax
80105453:	0f 84 c7 00 00 00    	je     80105520 <sys_unlink+0x160>
  ilock(ip);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	50                   	push   %eax
8010545d:	e8 3e c3 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010546a:	0f 8e 0a 01 00 00    	jle    8010557a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105470:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105475:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105478:	74 66                	je     801054e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010547a:	83 ec 04             	sub    $0x4,%esp
8010547d:	6a 10                	push   $0x10
8010547f:	6a 00                	push   $0x0
80105481:	57                   	push   %edi
80105482:	e8 69 f5 ff ff       	call   801049f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105487:	6a 10                	push   $0x10
80105489:	ff 75 c4             	push   -0x3c(%ebp)
8010548c:	57                   	push   %edi
8010548d:	ff 75 b4             	push   -0x4c(%ebp)
80105490:	e8 1b c7 ff ff       	call   80101bb0 <writei>
80105495:	83 c4 20             	add    $0x20,%esp
80105498:	83 f8 10             	cmp    $0x10,%eax
8010549b:	0f 85 cc 00 00 00    	jne    8010556d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801054a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a6:	0f 84 94 00 00 00    	je     80105540 <sys_unlink+0x180>
  iunlockput(dp);
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	ff 75 b4             	push   -0x4c(%ebp)
801054b2:	e8 79 c5 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801054b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054bc:	89 1c 24             	mov    %ebx,(%esp)
801054bf:	e8 2c c2 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801054c4:	89 1c 24             	mov    %ebx,(%esp)
801054c7:	e8 64 c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
801054cc:	e8 df d8 ff ff       	call   80102db0 <end_op>
  return 0;
801054d1:	83 c4 10             	add    $0x10,%esp
801054d4:	31 c0                	xor    %eax,%eax
}
801054d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d9:	5b                   	pop    %ebx
801054da:	5e                   	pop    %esi
801054db:	5f                   	pop    %edi
801054dc:	5d                   	pop    %ebp
801054dd:	c3                   	ret
801054de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054e4:	76 94                	jbe    8010547a <sys_unlink+0xba>
801054e6:	be 20 00 00 00       	mov    $0x20,%esi
801054eb:	eb 0b                	jmp    801054f8 <sys_unlink+0x138>
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
801054f0:	83 c6 10             	add    $0x10,%esi
801054f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801054f6:	73 82                	jae    8010547a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f8:	6a 10                	push   $0x10
801054fa:	56                   	push   %esi
801054fb:	57                   	push   %edi
801054fc:	53                   	push   %ebx
801054fd:	e8 ae c5 ff ff       	call   80101ab0 <readi>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	83 f8 10             	cmp    $0x10,%eax
80105508:	75 56                	jne    80105560 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010550a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010550f:	74 df                	je     801054f0 <sys_unlink+0x130>
    iunlockput(ip);
80105511:	83 ec 0c             	sub    $0xc,%esp
80105514:	53                   	push   %ebx
80105515:	e8 16 c5 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	ff 75 b4             	push   -0x4c(%ebp)
80105526:	e8 05 c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010552b:	e8 80 d8 ff ff       	call   80102db0 <end_op>
  return -1;
80105530:	83 c4 10             	add    $0x10,%esp
    return -1;
80105533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105538:	eb 9c                	jmp    801054d6 <sys_unlink+0x116>
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105540:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105543:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105546:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010554b:	50                   	push   %eax
8010554c:	e8 9f c1 ff ff       	call   801016f0 <iupdate>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	e9 53 ff ff ff       	jmp    801054ac <sys_unlink+0xec>
    end_op();
80105559:	e8 52 d8 ff ff       	call   80102db0 <end_op>
    return -1;
8010555e:	eb d3                	jmp    80105533 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	68 0d 8a 10 80       	push   $0x80108a0d
80105568:	e8 13 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	68 1f 8a 10 80       	push   $0x80108a1f
80105575:	e8 06 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	68 fb 89 10 80       	push   $0x801089fb
80105582:	e8 f9 ad ff ff       	call   80100380 <panic>
80105587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_open>:

int
sys_open(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105595:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105598:	53                   	push   %ebx
80105599:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 bc f7 ff ff       	call   80104d60 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 8e 00 00 00    	js     8010563d <sys_open+0xad>
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055b5:	50                   	push   %eax
801055b6:	6a 01                	push   $0x1
801055b8:	e8 e3 f6 ff ff       	call   80104ca0 <argint>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 79                	js     8010563d <sys_open+0xad>
    return -1;

  begin_op();
801055c4:	e8 77 d7 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
801055c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055cd:	75 79                	jne    80105648 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	ff 75 e0             	push   -0x20(%ebp)
801055d5:	e8 a6 ca ff ff       	call   80102080 <namei>
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	89 c6                	mov    %eax,%esi
801055df:	85 c0                	test   %eax,%eax
801055e1:	0f 84 7e 00 00 00    	je     80105665 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	50                   	push   %eax
801055eb:	e8 b0 c1 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055f8:	0f 84 ba 00 00 00    	je     801056b8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055fe:	e8 4d b8 ff ff       	call   80100e50 <filealloc>
80105603:	89 c7                	mov    %eax,%edi
80105605:	85 c0                	test   %eax,%eax
80105607:	74 23                	je     8010562c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105609:	e8 52 e3 ff ff       	call   80103960 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010560e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105610:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105614:	85 d2                	test   %edx,%edx
80105616:	74 58                	je     80105670 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105618:	83 c3 01             	add    $0x1,%ebx
8010561b:	83 fb 10             	cmp    $0x10,%ebx
8010561e:	75 f0                	jne    80105610 <sys_open+0x80>
    if(f)
      fileclose(f);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	57                   	push   %edi
80105624:	e8 e7 b8 ff ff       	call   80100f10 <fileclose>
80105629:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	56                   	push   %esi
80105630:	e8 fb c3 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105635:	e8 76 d7 ff ff       	call   80102db0 <end_op>
    return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010563d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105642:	eb 65                	jmp    801056a9 <sys_open+0x119>
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	31 c9                	xor    %ecx,%ecx
8010564d:	ba 02 00 00 00       	mov    $0x2,%edx
80105652:	6a 00                	push   $0x0
80105654:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105657:	e8 f4 f7 ff ff       	call   80104e50 <create>
    if(ip == 0){
8010565c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010565f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105661:	85 c0                	test   %eax,%eax
80105663:	75 99                	jne    801055fe <sys_open+0x6e>
      end_op();
80105665:	e8 46 d7 ff ff       	call   80102db0 <end_op>
      return -1;
8010566a:	eb d1                	jmp    8010563d <sys_open+0xad>
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105673:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105677:	56                   	push   %esi
80105678:	e8 03 c2 ff ff       	call   80101880 <iunlock>
  end_op();
8010567d:	e8 2e d7 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105682:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010568b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010568e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105691:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105693:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010569a:	f7 d0                	not    %eax
8010569c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010569f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056a2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ac:	89 d8                	mov    %ebx,%eax
801056ae:	5b                   	pop    %ebx
801056af:	5e                   	pop    %esi
801056b0:	5f                   	pop    %edi
801056b1:	5d                   	pop    %ebp
801056b2:	c3                   	ret
801056b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056b7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801056b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056bb:	85 c9                	test   %ecx,%ecx
801056bd:	0f 84 3b ff ff ff    	je     801055fe <sys_open+0x6e>
801056c3:	e9 64 ff ff ff       	jmp    8010562c <sys_open+0x9c>
801056c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop

801056d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056d6:	e8 65 d6 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056db:	83 ec 08             	sub    $0x8,%esp
801056de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e1:	50                   	push   %eax
801056e2:	6a 00                	push   $0x0
801056e4:	e8 77 f6 ff ff       	call   80104d60 <argstr>
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	85 c0                	test   %eax,%eax
801056ee:	78 30                	js     80105720 <sys_mkdir+0x50>
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f6:	31 c9                	xor    %ecx,%ecx
801056f8:	ba 01 00 00 00       	mov    $0x1,%edx
801056fd:	6a 00                	push   $0x0
801056ff:	e8 4c f7 ff ff       	call   80104e50 <create>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	74 15                	je     80105720 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010570b:	83 ec 0c             	sub    $0xc,%esp
8010570e:	50                   	push   %eax
8010570f:	e8 1c c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105714:	e8 97 d6 ff ff       	call   80102db0 <end_op>
  return 0;
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	31 c0                	xor    %eax,%eax
}
8010571e:	c9                   	leave
8010571f:	c3                   	ret
    end_op();
80105720:	e8 8b d6 ff ff       	call   80102db0 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572a:	c9                   	leave
8010572b:	c3                   	ret
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_mknod>:

int
sys_mknod(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105736:	e8 05 d6 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010573b:	83 ec 08             	sub    $0x8,%esp
8010573e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 17 f6 ff ff       	call   80104d60 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 60                	js     801057b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105750:	83 ec 08             	sub    $0x8,%esp
80105753:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105756:	50                   	push   %eax
80105757:	6a 01                	push   $0x1
80105759:	e8 42 f5 ff ff       	call   80104ca0 <argint>
  if((argstr(0, &path)) < 0 ||
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	85 c0                	test   %eax,%eax
80105763:	78 4b                	js     801057b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576b:	50                   	push   %eax
8010576c:	6a 02                	push   $0x2
8010576e:	e8 2d f5 ff ff       	call   80104ca0 <argint>
     argint(1, &major) < 0 ||
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	78 36                	js     801057b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010577a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010577e:	83 ec 0c             	sub    $0xc,%esp
80105781:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105785:	ba 03 00 00 00       	mov    $0x3,%edx
8010578a:	50                   	push   %eax
8010578b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010578e:	e8 bd f6 ff ff       	call   80104e50 <create>
     argint(2, &minor) < 0 ||
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	74 16                	je     801057b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010579a:	83 ec 0c             	sub    $0xc,%esp
8010579d:	50                   	push   %eax
8010579e:	e8 8d c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
801057a3:	e8 08 d6 ff ff       	call   80102db0 <end_op>
  return 0;
801057a8:	83 c4 10             	add    $0x10,%esp
801057ab:	31 c0                	xor    %eax,%eax
}
801057ad:	c9                   	leave
801057ae:	c3                   	ret
801057af:	90                   	nop
    end_op();
801057b0:	e8 fb d5 ff ff       	call   80102db0 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ba:	c9                   	leave
801057bb:	c3                   	ret
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_chdir>:

int
sys_chdir(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
801057c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057c8:	e8 93 e1 ff ff       	call   80103960 <myproc>
801057cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057cf:	e8 6c d5 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057d4:	83 ec 08             	sub    $0x8,%esp
801057d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057da:	50                   	push   %eax
801057db:	6a 00                	push   $0x0
801057dd:	e8 7e f5 ff ff       	call   80104d60 <argstr>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	78 77                	js     80105860 <sys_chdir+0xa0>
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	ff 75 f4             	push   -0xc(%ebp)
801057ef:	e8 8c c8 ff ff       	call   80102080 <namei>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	89 c3                	mov    %eax,%ebx
801057f9:	85 c0                	test   %eax,%eax
801057fb:	74 63                	je     80105860 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	50                   	push   %eax
80105801:	e8 9a bf ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010580e:	75 30                	jne    80105840 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	53                   	push   %ebx
80105814:	e8 67 c0 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105819:	58                   	pop    %eax
8010581a:	ff 76 68             	push   0x68(%esi)
8010581d:	e8 ae c0 ff ff       	call   801018d0 <iput>
  end_op();
80105822:	e8 89 d5 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105827:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	31 c0                	xor    %eax,%eax
}
8010582f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105832:	5b                   	pop    %ebx
80105833:	5e                   	pop    %esi
80105834:	5d                   	pop    %ebp
80105835:	c3                   	ret
80105836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	53                   	push   %ebx
80105844:	e8 e7 c1 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105849:	e8 62 d5 ff ff       	call   80102db0 <end_op>
    return -1;
8010584e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105856:	eb d7                	jmp    8010582f <sys_chdir+0x6f>
80105858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
    end_op();
80105860:	e8 4b d5 ff ff       	call   80102db0 <end_op>
    return -1;
80105865:	eb ea                	jmp    80105851 <sys_chdir+0x91>
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax

80105870 <sys_exec>:

int
sys_exec(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105875:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010587b:	53                   	push   %ebx
8010587c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105882:	50                   	push   %eax
80105883:	6a 00                	push   $0x0
80105885:	e8 d6 f4 ff ff       	call   80104d60 <argstr>
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	85 c0                	test   %eax,%eax
8010588f:	0f 88 87 00 00 00    	js     8010591c <sys_exec+0xac>
80105895:	83 ec 08             	sub    $0x8,%esp
80105898:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010589e:	50                   	push   %eax
8010589f:	6a 01                	push   $0x1
801058a1:	e8 fa f3 ff ff       	call   80104ca0 <argint>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	78 6f                	js     8010591c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058ad:	83 ec 04             	sub    $0x4,%esp
801058b0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801058b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801058b8:	68 80 00 00 00       	push   $0x80
801058bd:	6a 00                	push   $0x0
801058bf:	56                   	push   %esi
801058c0:	e8 2b f1 ff ff       	call   801049f0 <memset>
801058c5:	83 c4 10             	add    $0x10,%esp
801058c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058d0:	83 ec 08             	sub    $0x8,%esp
801058d3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058d9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801058e0:	50                   	push   %eax
801058e1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058e7:	01 f8                	add    %edi,%eax
801058e9:	50                   	push   %eax
801058ea:	e8 21 f3 ff ff       	call   80104c10 <fetchint>
801058ef:	83 c4 10             	add    $0x10,%esp
801058f2:	85 c0                	test   %eax,%eax
801058f4:	78 26                	js     8010591c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058f6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058fc:	85 c0                	test   %eax,%eax
801058fe:	74 30                	je     80105930 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105906:	52                   	push   %edx
80105907:	50                   	push   %eax
80105908:	e8 43 f3 ff ff       	call   80104c50 <fetchstr>
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	85 c0                	test   %eax,%eax
80105912:	78 08                	js     8010591c <sys_exec+0xac>
  for(i=0;; i++){
80105914:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105917:	83 fb 20             	cmp    $0x20,%ebx
8010591a:	75 b4                	jne    801058d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010591c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010591f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105930:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105937:	00 00 00 00 
  return exec(path, argv);
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	56                   	push   %esi
8010593f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105945:	e8 66 b1 ff ff       	call   80100ab0 <exec>
8010594a:	83 c4 10             	add    $0x10,%esp
}
8010594d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105950:	5b                   	pop    %ebx
80105951:	5e                   	pop    %esi
80105952:	5f                   	pop    %edi
80105953:	5d                   	pop    %ebp
80105954:	c3                   	ret
80105955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_pipe>:

int
sys_pipe(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105965:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105968:	53                   	push   %ebx
80105969:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010596c:	6a 08                	push   $0x8
8010596e:	50                   	push   %eax
8010596f:	6a 00                	push   $0x0
80105971:	e8 7a f3 ff ff       	call   80104cf0 <argptr>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	0f 88 8b 00 00 00    	js     80105a0c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105981:	83 ec 08             	sub    $0x8,%esp
80105984:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105987:	50                   	push   %eax
80105988:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010598b:	50                   	push   %eax
8010598c:	e8 7f da ff ff       	call   80103410 <pipealloc>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	78 74                	js     80105a0c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105998:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010599b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010599d:	e8 be df ff ff       	call   80103960 <myproc>
    if(curproc->ofile[fd] == 0){
801059a2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059a6:	85 f6                	test   %esi,%esi
801059a8:	74 16                	je     801059c0 <sys_pipe+0x60>
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801059b0:	83 c3 01             	add    $0x1,%ebx
801059b3:	83 fb 10             	cmp    $0x10,%ebx
801059b6:	74 3d                	je     801059f5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801059b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059bc:	85 f6                	test   %esi,%esi
801059be:	75 f0                	jne    801059b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801059c0:	8d 73 08             	lea    0x8(%ebx),%esi
801059c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059ca:	e8 91 df ff ff       	call   80103960 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059cf:	31 d2                	xor    %edx,%edx
801059d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059d8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059dc:	85 c9                	test   %ecx,%ecx
801059de:	74 38                	je     80105a18 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801059e0:	83 c2 01             	add    $0x1,%edx
801059e3:	83 fa 10             	cmp    $0x10,%edx
801059e6:	75 f0                	jne    801059d8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801059e8:	e8 73 df ff ff       	call   80103960 <myproc>
801059ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059f4:	00 
    fileclose(rf);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	ff 75 e0             	push   -0x20(%ebp)
801059fb:	e8 10 b5 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105a00:	58                   	pop    %eax
80105a01:	ff 75 e4             	push   -0x1c(%ebp)
80105a04:	e8 07 b5 ff ff       	call   80100f10 <fileclose>
    return -1;
80105a09:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a11:	eb 16                	jmp    80105a29 <sys_pipe+0xc9>
80105a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a17:	90                   	nop
      curproc->ofile[fd] = f;
80105a18:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a1f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a24:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a27:	31 c0                	xor    %eax,%eax
}
80105a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2c:	5b                   	pop    %ebx
80105a2d:	5e                   	pop    %esi
80105a2e:	5f                   	pop    %edi
80105a2f:	5d                   	pop    %ebp
80105a30:	c3                   	ret
80105a31:	66 90                	xchg   %ax,%ax
80105a33:	66 90                	xchg   %ax,%ax
80105a35:	66 90                	xchg   %ax,%ax
80105a37:	66 90                	xchg   %ax,%ax
80105a39:	66 90                	xchg   %ax,%ax
80105a3b:	66 90                	xchg   %ax,%ax
80105a3d:	66 90                	xchg   %ax,%ax
80105a3f:	90                   	nop

80105a40 <sys_fork>:
#define NULL 0

int
sys_fork(void)
{
  return fork();
80105a40:	e9 9b e1 ff ff       	jmp    80103be0 <fork>
80105a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_exit>:
}

int
sys_exit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a56:	e8 15 e6 ff ff       	call   80104070 <exit>
  return 0;  // not reached
}
80105a5b:	31 c0                	xor    %eax,%eax
80105a5d:	c9                   	leave
80105a5e:	c3                   	ret
80105a5f:	90                   	nop

80105a60 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a60:	e9 8b e7 ff ff       	jmp    801041f0 <wait>
80105a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_kill>:
}

int
sys_kill(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 00                	push   $0x0
80105a7c:	e8 1f f2 ff ff       	call   80104ca0 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 18                	js     80105aa0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 f4             	push   -0xc(%ebp)
80105a8e:	e8 fd e9 ff ff       	call   80104490 <kill>
80105a93:	83 c4 10             	add    $0x10,%esp
}
80105a96:	c9                   	leave
80105a97:	c3                   	ret
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
80105aa0:	c9                   	leave
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa6:	c3                   	ret
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_getpid>:

int
sys_getpid(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ab6:	e8 a5 de ff ff       	call   80103960 <myproc>
80105abb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105abe:	c9                   	leave
80105abf:	c3                   	ret

80105ac0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 ce f1 ff ff       	call   80104ca0 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 27                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ad9:	e8 82 de ff ff       	call   80103960 <myproc>
  if(growproc(n) < 0)
80105ade:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ae1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ae3:	ff 75 f4             	push   -0xc(%ebp)
80105ae6:	e8 e5 df ff ff       	call   80103ad0 <growproc>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	85 c0                	test   %eax,%eax
80105af0:	78 0e                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105af2:	89 d8                	mov    %ebx,%eax
80105af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af7:	c9                   	leave
80105af8:	c3                   	ret
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b05:	eb eb                	jmp    80105af2 <sys_sbrk+0x32>
80105b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_sleep>:

int
sys_sleep(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 7e f1 ff ff       	call   80104ca0 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 64                	js     80105b8d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	68 80 fc 14 80       	push   $0x8014fc80
80105b31:	e8 ba ed ff ff       	call   801048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b39:	8b 1d 60 fc 14 80    	mov    0x8014fc60,%ebx
  while(ticks - ticks0 < n){
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	85 d2                	test   %edx,%edx
80105b44:	75 2b                	jne    80105b71 <sys_sleep+0x61>
80105b46:	eb 58                	jmp    80105ba0 <sys_sleep+0x90>
80105b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 80 fc 14 80       	push   $0x8014fc80
80105b58:	68 60 fc 14 80       	push   $0x8014fc60
80105b5d:	e8 0e e8 ff ff       	call   80104370 <sleep>
  while(ticks - ticks0 < n){
80105b62:	a1 60 fc 14 80       	mov    0x8014fc60,%eax
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	29 d8                	sub    %ebx,%eax
80105b6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b6f:	73 2f                	jae    80105ba0 <sys_sleep+0x90>
    if(myproc()->killed){
80105b71:	e8 ea dd ff ff       	call   80103960 <myproc>
80105b76:	8b 40 24             	mov    0x24(%eax),%eax
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 d3                	je     80105b50 <sys_sleep+0x40>
      release(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 80 fc 14 80       	push   $0x8014fc80
80105b85:	e8 06 ed ff ff       	call   80104890 <release>
      return -1;
80105b8a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b95:	c9                   	leave
80105b96:	c3                   	ret
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 80 fc 14 80       	push   $0x8014fc80
80105ba8:	e8 e3 ec ff ff       	call   80104890 <release>
}
80105bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	31 c0                	xor    %eax,%eax
}
80105bb5:	c9                   	leave
80105bb6:	c3                   	ret
80105bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
80105bc4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bc7:	68 80 fc 14 80       	push   $0x8014fc80
80105bcc:	e8 1f ed ff ff       	call   801048f0 <acquire>
  xticks = ticks;
80105bd1:	8b 1d 60 fc 14 80    	mov    0x8014fc60,%ebx
  release(&tickslock);
80105bd7:	c7 04 24 80 fc 14 80 	movl   $0x8014fc80,(%esp)
80105bde:	e8 ad ec ff ff       	call   80104890 <release>
  return xticks;
}
80105be3:	89 d8                	mov    %ebx,%eax
80105be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be8:	c9                   	leave
80105be9:	c3                   	ret
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bf0 <checkAddr>:

// Returns whether the address can be used or if it
// is already in use by another address
int checkAddr(uint startingAddr, uint endingAddr){
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
	int count = 0;
80105bf5:	31 f6                	xor    %esi,%esi
int checkAddr(uint startingAddr, uint endingAddr){
80105bf7:	53                   	push   %ebx
80105bf8:	bb 0f 00 00 00       	mov    $0xf,%ebx
80105bfd:	83 ec 0c             	sub    $0xc,%esp
		}
		
		if(endingAddr < ((myproc()->allAddresses)[i].startingVirtualAddr) && endingAddr >= ((myproc()->allAddresses)[i].endingVirtualAddr)){
			return 0;
		}*/
		if(((myproc()->allAddresses)[i].startingVirtualAddr) == 0){
80105c00:	e8 5b dd ff ff       	call   80103960 <myproc>
80105c05:	69 fb e8 00 00 00    	imul   $0xe8,%ebx,%edi
80105c0b:	8b 54 07 7c          	mov    0x7c(%edi,%eax,1),%edx
80105c0f:	85 d2                	test   %edx,%edx
80105c11:	74 3d                	je     80105c50 <checkAddr+0x60>
			count++;
			continue;
		}
		else if(((myproc()->allAddresses)[i+1].endingVirtualAddr) == 0 && startingAddr >= ((myproc()->allAddresses)[i].endingVirtualAddr)){
80105c13:	e8 48 dd ff ff       	call   80103960 <myproc>
80105c18:	89 c2                	mov    %eax,%edx
80105c1a:	8d 43 01             	lea    0x1(%ebx),%eax
80105c1d:	69 c0 e8 00 00 00    	imul   $0xe8,%eax,%eax
80105c23:	8b 84 10 80 00 00 00 	mov    0x80(%eax,%edx,1),%eax
80105c2a:	85 c0                	test   %eax,%eax
80105c2c:	74 7a                	je     80105ca8 <checkAddr+0xb8>
			return 1;
		}
		else if(i-1 >= 0 && startingAddr >= ((myproc()->allAddresses)[i-1].endingVirtualAddr) && endingAddr <= ((myproc()->allAddresses)[i].startingVirtualAddr)){
80105c2e:	85 db                	test   %ebx,%ebx
80105c30:	75 2e                	jne    80105c60 <checkAddr+0x70>
			return 1;
		}
		else if(i == 0 && endingAddr <= ((myproc()->allAddresses)[i].startingVirtualAddr)){
80105c32:	e8 29 dd ff ff       	call   80103960 <myproc>
80105c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c3a:	39 48 7c             	cmp    %ecx,0x7c(%eax)
80105c3d:	73 55                	jae    80105c94 <checkAddr+0xa4>
			return 1;
		}
	}

	if(count >= 16){
80105c3f:	31 c0                	xor    %eax,%eax
80105c41:	83 fe 0f             	cmp    $0xf,%esi
80105c44:	0f 9f c0             	setg   %al
		//cprintf("HELLOOOOOOOOO\n");
		return 1;
	}
	return 0;
}
80105c47:	83 c4 0c             	add    $0xc,%esp
80105c4a:	5b                   	pop    %ebx
80105c4b:	5e                   	pop    %esi
80105c4c:	5f                   	pop    %edi
80105c4d:	5d                   	pop    %ebp
80105c4e:	c3                   	ret
80105c4f:	90                   	nop
			count++;
80105c50:	83 c6 01             	add    $0x1,%esi
	for(int i=15; i>=0; i--){
80105c53:	83 eb 01             	sub    $0x1,%ebx
80105c56:	73 a8                	jae    80105c00 <checkAddr+0x10>
80105c58:	eb e5                	jmp    80105c3f <checkAddr+0x4f>
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		else if(i-1 >= 0 && startingAddr >= ((myproc()->allAddresses)[i-1].endingVirtualAddr) && endingAddr <= ((myproc()->allAddresses)[i].startingVirtualAddr)){
80105c60:	e8 fb dc ff ff       	call   80103960 <myproc>
80105c65:	8d 7b ff             	lea    -0x1(%ebx),%edi
80105c68:	69 d7 e8 00 00 00    	imul   $0xe8,%edi,%edx
80105c6e:	8b 84 02 80 00 00 00 	mov    0x80(%edx,%eax,1),%eax
80105c75:	39 45 08             	cmp    %eax,0x8(%ebp)
80105c78:	73 06                	jae    80105c80 <checkAddr+0x90>
	for(int i=15; i>=0; i--){
80105c7a:	89 fb                	mov    %edi,%ebx
80105c7c:	eb 82                	jmp    80105c00 <checkAddr+0x10>
80105c7e:	66 90                	xchg   %ax,%ax
		else if(i-1 >= 0 && startingAddr >= ((myproc()->allAddresses)[i-1].endingVirtualAddr) && endingAddr <= ((myproc()->allAddresses)[i].startingVirtualAddr)){
80105c80:	e8 db dc ff ff       	call   80103960 <myproc>
80105c85:	69 db e8 00 00 00    	imul   $0xe8,%ebx,%ebx
80105c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c8e:	39 4c 03 7c          	cmp    %ecx,0x7c(%ebx,%eax,1)
80105c92:	72 e6                	jb     80105c7a <checkAddr+0x8a>
}
80105c94:	83 c4 0c             	add    $0xc,%esp
			return 1;
80105c97:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c9c:	5b                   	pop    %ebx
80105c9d:	5e                   	pop    %esi
80105c9e:	5f                   	pop    %edi
80105c9f:	5d                   	pop    %ebp
80105ca0:	c3                   	ret
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		else if(((myproc()->allAddresses)[i+1].endingVirtualAddr) == 0 && startingAddr >= ((myproc()->allAddresses)[i].endingVirtualAddr)){
80105ca8:	e8 b3 dc ff ff       	call   80103960 <myproc>
80105cad:	8b 84 07 80 00 00 00 	mov    0x80(%edi,%eax,1),%eax
80105cb4:	39 45 08             	cmp    %eax,0x8(%ebp)
80105cb7:	0f 82 71 ff ff ff    	jb     80105c2e <checkAddr+0x3e>
80105cbd:	eb d5                	jmp    80105c94 <checkAddr+0xa4>
80105cbf:	90                   	nop

80105cc0 <findAvailableAddr>:

// Finds an address that is not already in use
int findAvailableAddr(int length){
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
	uint checkedAddress = 0x60000000;
	int foundValid = 0;
	//cprintf("%x %x\n",((myproc()->allAddresses)[0].startingVirtualAddr), ((myproc()->allAddresses)[0].endingVirtualAddr));
	//cprintf("CHECKING TRUTH: %x %x %x %x", checkedAddress >= ((myproc()->allAddresses)[0].startingVirtualAddr), checkedAddress < ((myproc()->allAddresses)[0].endingVirtualAddr), checkedAddress+length >= ((myproc()->allAddresses)[0].startingVirtualAddr), checkedAddress+length < ((myproc()->allAddresses)[0].endingVirtualAddr));
	//cprintf("CHECKING TRUTH: %x, %x, %x, %x\n", ((myproc()->allAddresses)[0].startingVirtualAddr) == 0, checkedAddress > ((myproc()->allAddresses)[0].endingVirtualAddr), checkedAddress+length < ((myproc()->allAddresses)[0].startingVirtualAddr));
	while(checkedAddress < 0x80000000){
80105cc5:	be 00 00 00 60       	mov    $0x60000000,%esi
int findAvailableAddr(int length){
80105cca:	53                   	push   %ebx
	uint checkedAddress = 0x60000000;
80105ccb:	bb 00 00 00 60       	mov    $0x60000000,%ebx
int findAvailableAddr(int length){
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	8b 7d 08             	mov    0x8(%ebp),%edi
80105cd6:	eb 18                	jmp    80105cf0 <findAvailableAddr+0x30>
80105cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
		foundValid = checkAddr(checkedAddress, checkedAddress+length);

		if(foundValid == 1)
			break;

		checkedAddress += 4096;
80105ce0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	while(checkedAddress < 0x80000000){
80105ce6:	89 de                	mov    %ebx,%esi
80105ce8:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80105cee:	74 15                	je     80105d05 <findAvailableAddr+0x45>
		foundValid = checkAddr(checkedAddress, checkedAddress+length);
80105cf0:	83 ec 08             	sub    $0x8,%esp
80105cf3:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
80105cf6:	50                   	push   %eax
80105cf7:	53                   	push   %ebx
80105cf8:	e8 f3 fe ff ff       	call   80105bf0 <checkAddr>
		if(foundValid == 1)
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	83 f8 01             	cmp    $0x1,%eax
80105d03:	75 db                	jne    80105ce0 <findAvailableAddr+0x20>
	}
	//cprintf("%x %x\n", checkedAddress, checkedAddress+length);

	return checkedAddress;
}
80105d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d08:	89 f0                	mov    %esi,%eax
80105d0a:	5b                   	pop    %ebx
80105d0b:	5e                   	pop    %esi
80105d0c:	5f                   	pop    %edi
80105d0d:	5d                   	pop    %ebp
80105d0e:	c3                   	ret
80105d0f:	90                   	nop

80105d10 <addAddress>:

// Adds the address into the appropriate spot
void addAddress(uint startingAddr, uint endingAddr, int pages, int isPrivate, int isAnonymous, struct file *fd, int length){
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	53                   	push   %ebx
80105d16:	83 ec 2c             	sub    $0x2c,%esp
80105d19:	8b 7d 08             	mov    0x8(%ebp),%edi
80105d1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int placeHolder = 0;
	int count = 0;
	struct proc *currproc = myproc();
80105d1f:	e8 3c dc ff ff       	call   80103960 <myproc>
80105d24:	89 c3                	mov    %eax,%ebx

	// Checks where the address needs to be added
	for(count=15; count>=0; count--){
80105d26:	8d 90 30 0d 00 00    	lea    0xd30(%eax),%edx
80105d2c:	b8 0f 00 00 00       	mov    $0xf,%eax
80105d31:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				//cprintf("hi\n");
			}else{
				//cprintf("hello\n");
				placeHolder = 1;
			}
		}else if(currproc->allAddresses[count - 1].endingVirtualAddr < startingAddr && currproc->allAddresses[count].startingVirtualAddr > endingAddr){
80105d38:	89 c3                	mov    %eax,%ebx
80105d3a:	83 e8 01             	sub    $0x1,%eax
80105d3d:	39 3a                	cmp    %edi,(%edx)
80105d3f:	73 0c                	jae    80105d4d <addAddress+0x3d>
80105d41:	3b b2 e4 00 00 00    	cmp    0xe4(%edx),%esi
80105d47:	0f 82 4c 02 00 00    	jb     80105f99 <addAddress+0x289>
			placeHolder = count;
			//cprintf("hi\n");
			//cprintf("%d) %x < %x && %x < %x\n", count, currproc->allAddresses[count + 1].endingVirtualAddr, startingAddr, endingAddr, currproc->allAddresses[count].startingVirtualAddr);
			break;
		}else if(currproc->allAddresses[count].endingVirtualAddr < startingAddr && currproc->allAddresses[count].endingVirtualAddr != 0){
80105d4d:	8b 8a e8 00 00 00    	mov    0xe8(%edx),%ecx
80105d53:	81 ea e8 00 00 00    	sub    $0xe8,%edx
80105d59:	85 c9                	test   %ecx,%ecx
80105d5b:	74 08                	je     80105d65 <addAddress+0x55>
80105d5d:	39 f9                	cmp    %edi,%ecx
80105d5f:	0f 82 4b 02 00 00    	jb     80105fb0 <addAddress+0x2a0>
		if(count == 0){
80105d65:	85 c0                	test   %eax,%eax
80105d67:	75 cf                	jne    80105d38 <addAddress+0x28>
			if(currproc->allAddresses[count].startingVirtualAddr == 0){
80105d69:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105d6c:	8b 53 7c             	mov    0x7c(%ebx),%edx
			else if(endingAddr <= currproc->allAddresses[count].startingVirtualAddr){
80105d6f:	39 f2                	cmp    %esi,%edx
80105d71:	0f 93 c0             	setae  %al
			if(currproc->allAddresses[count].startingVirtualAddr == 0){
80105d74:	85 d2                	test   %edx,%edx
80105d76:	0f 94 c2             	sete   %dl
			else if(endingAddr <= currproc->allAddresses[count].startingVirtualAddr){
80105d79:	09 d0                	or     %edx,%eax
80105d7b:	83 f0 01             	xor    $0x1,%eax
80105d7e:	0f b6 c0             	movzbl %al,%eax
80105d81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	//cprintf("%x\n", currproc->allAddresses[1].startingVirtualAddr > endingAddr);
	//cprintf("final count: %d\n", placeHolder);

	// Shifts all the addresses that come after the new one
	// to the right by one spot
	for(int i=15; i>placeHolder; i--){
80105d84:	c7 45 d8 0f 00 00 00 	movl   $0xf,-0x28(%ebp)
80105d8b:	89 7d 08             	mov    %edi,0x8(%ebp)
80105d8e:	89 75 0c             	mov    %esi,0xc(%ebp)
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		((myproc()->allAddresses)[i]).startingVirtualAddr = ((myproc()->allAddresses)[i-1]).startingVirtualAddr;
80105d98:	e8 c3 db ff ff       	call   80103960 <myproc>
80105d9d:	89 c3                	mov    %eax,%ebx
80105d9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105da2:	89 c6                	mov    %eax,%esi
80105da4:	83 e8 01             	sub    $0x1,%eax
80105da7:	89 c7                	mov    %eax,%edi
80105da9:	e8 b2 db ff ff       	call   80103960 <myproc>
80105dae:	89 7d d8             	mov    %edi,-0x28(%ebp)
80105db1:	69 ff e8 00 00 00    	imul   $0xe8,%edi,%edi
80105db7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80105dba:	8b 54 3b 7c          	mov    0x7c(%ebx,%edi,1),%edx
80105dbe:	69 de e8 00 00 00    	imul   $0xe8,%esi,%ebx
80105dc4:	89 54 03 7c          	mov    %edx,0x7c(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).endingVirtualAddr = ((myproc()->allAddresses)[i-1]).endingVirtualAddr;
80105dc8:	e8 93 db ff ff       	call   80103960 <myproc>
80105dcd:	89 c6                	mov    %eax,%esi
80105dcf:	e8 8c db ff ff       	call   80103960 <myproc>
80105dd4:	8b 94 3e 80 00 00 00 	mov    0x80(%esi,%edi,1),%edx
80105ddb:	89 94 03 80 00 00 00 	mov    %edx,0x80(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).numberOfPages = ((myproc()->allAddresses)[i-1]).numberOfPages;
80105de2:	e8 79 db ff ff       	call   80103960 <myproc>
80105de7:	89 c6                	mov    %eax,%esi
80105de9:	e8 72 db ff ff       	call   80103960 <myproc>
80105dee:	8b 94 3e 88 00 00 00 	mov    0x88(%esi,%edi,1),%edx
80105df5:	89 94 03 88 00 00 00 	mov    %edx,0x88(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).refCount = ((myproc()->allAddresses)[i-1]).refCount;
80105dfc:	e8 5f db ff ff       	call   80103960 <myproc>
80105e01:	89 c6                	mov    %eax,%esi
80105e03:	e8 58 db ff ff       	call   80103960 <myproc>
80105e08:	8b 94 3e 4c 01 00 00 	mov    0x14c(%esi,%edi,1),%edx
80105e0f:	89 94 03 4c 01 00 00 	mov    %edx,0x14c(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).isPrivate = ((myproc()->allAddresses)[i-1]).isPrivate;
80105e16:	e8 45 db ff ff       	call   80103960 <myproc>
80105e1b:	89 c6                	mov    %eax,%esi
80105e1d:	e8 3e db ff ff       	call   80103960 <myproc>
80105e22:	8b 94 3e 50 01 00 00 	mov    0x150(%esi,%edi,1),%edx
80105e29:	89 94 03 50 01 00 00 	mov    %edx,0x150(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).isAnonymous = ((myproc()->allAddresses)[i-1]).isAnonymous;
80105e30:	e8 2b db ff ff       	call   80103960 <myproc>
80105e35:	89 c6                	mov    %eax,%esi
80105e37:	e8 24 db ff ff       	call   80103960 <myproc>
80105e3c:	8b 94 3e 54 01 00 00 	mov    0x154(%esi,%edi,1),%edx
80105e43:	89 94 03 54 01 00 00 	mov    %edx,0x154(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).fd = ((myproc()->allAddresses)[i-1]).fd;
80105e4a:	e8 11 db ff ff       	call   80103960 <myproc>
80105e4f:	89 c6                	mov    %eax,%esi
80105e51:	e8 0a db ff ff       	call   80103960 <myproc>
80105e56:	8b 94 3e 58 01 00 00 	mov    0x158(%esi,%edi,1),%edx
80105e5d:	89 94 03 58 01 00 00 	mov    %edx,0x158(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).length = ((myproc()->allAddresses)[i-1]).length;
80105e64:	e8 f7 da ff ff       	call   80103960 <myproc>
80105e69:	89 c6                	mov    %eax,%esi
80105e6b:	e8 f0 da ff ff       	call   80103960 <myproc>
80105e70:	8b 94 3e 60 01 00 00 	mov    0x160(%esi,%edi,1),%edx
80105e77:	89 94 03 60 01 00 00 	mov    %edx,0x160(%ebx,%eax,1)
		((myproc()->allAddresses)[i]).physicalPageNumber = ((myproc()->allAddresses)[i-1]).physicalPageNumber;		 
80105e7e:	e8 dd da ff ff       	call   80103960 <myproc>
80105e83:	89 c6                	mov    %eax,%esi
80105e85:	e8 d6 da ff ff       	call   80103960 <myproc>
80105e8a:	8b 94 3e 84 00 00 00 	mov    0x84(%esi,%edi,1),%edx
		for(int j=0; j<32; j++){
			((myproc()->allAddresses)[i]).startingPhysicalAddr[j] = ((myproc()->allAddresses)[i-1]).startingPhysicalAddr[j];
80105e91:	6b 7d e4 3a          	imul   $0x3a,-0x1c(%ebp),%edi
		((myproc()->allAddresses)[i]).physicalPageNumber = ((myproc()->allAddresses)[i-1]).physicalPageNumber;		 
80105e95:	89 94 03 84 00 00 00 	mov    %edx,0x84(%ebx,%eax,1)
			((myproc()->allAddresses)[i]).startingPhysicalAddr[j] = ((myproc()->allAddresses)[i-1]).startingPhysicalAddr[j];
80105e9c:	6b 45 d8 3a          	imul   $0x3a,-0x28(%ebp),%eax
		for(int j=0; j<32; j++){
80105ea0:	31 db                	xor    %ebx,%ebx
			((myproc()->allAddresses)[i]).startingPhysicalAddr[j] = ((myproc()->allAddresses)[i-1]).startingPhysicalAddr[j];
80105ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ea5:	8d 76 00             	lea    0x0(%esi),%esi
80105ea8:	e8 b3 da ff ff       	call   80103960 <myproc>
80105ead:	89 c6                	mov    %eax,%esi
80105eaf:	e8 ac da ff ff       	call   80103960 <myproc>
80105eb4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105eb7:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
80105eba:	8b 8c 96 8c 00 00 00 	mov    0x8c(%esi,%edx,4),%ecx
80105ec1:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80105ec4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105ec7:	89 8c b0 8c 00 00 00 	mov    %ecx,0x8c(%eax,%esi,4)
			if(j<16){
80105ece:	83 fb 0f             	cmp    $0xf,%ebx
80105ed1:	7f 2d                	jg     80105f00 <addAddress+0x1f0>
				((myproc()->allAddresses)[i]).forFork[j] = ((myproc()->allAddresses)[i-1]).forFork[j];
80105ed3:	e8 88 da ff ff       	call   80103960 <myproc>
		for(int j=0; j<32; j++){
80105ed8:	83 c3 01             	add    $0x1,%ebx
				((myproc()->allAddresses)[i]).forFork[j] = ((myproc()->allAddresses)[i-1]).forFork[j];
80105edb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ede:	e8 7d da ff ff       	call   80103960 <myproc>
80105ee3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105ee6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105ee9:	8b 94 91 0c 01 00 00 	mov    0x10c(%ecx,%edx,4),%edx
80105ef0:	89 94 b0 0c 01 00 00 	mov    %edx,0x10c(%eax,%esi,4)
		for(int j=0; j<32; j++){
80105ef7:	eb af                	jmp    80105ea8 <addAddress+0x198>
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f00:	83 c3 01             	add    $0x1,%ebx
80105f03:	83 fb 20             	cmp    $0x20,%ebx
80105f06:	75 a0                	jne    80105ea8 <addAddress+0x198>
	for(int i=15; i>placeHolder; i--){
80105f08:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80105f0b:	39 7d d8             	cmp    %edi,-0x28(%ebp)
80105f0e:	0f 85 84 fe ff ff    	jne    80105d98 <addAddress+0x88>
80105f14:	8b 7d 08             	mov    0x8(%ebp),%edi
80105f17:	8b 75 0c             	mov    0xc(%ebp),%esi
			}
		}
	}

	// Adds the address to the array and adds the necessary info
	((myproc()->allAddresses)[placeHolder]).startingVirtualAddr = startingAddr;
80105f1a:	e8 41 da ff ff       	call   80103960 <myproc>
80105f1f:	69 5d d4 e8 00 00 00 	imul   $0xe8,-0x2c(%ebp),%ebx
80105f26:	89 7c 03 7c          	mov    %edi,0x7c(%ebx,%eax,1)
	((myproc()->allAddresses)[placeHolder]).endingVirtualAddr = endingAddr;
80105f2a:	e8 31 da ff ff       	call   80103960 <myproc>
80105f2f:	89 b4 03 80 00 00 00 	mov    %esi,0x80(%ebx,%eax,1)
	((myproc()->allAddresses)[placeHolder]).numberOfPages = pages;
80105f36:	e8 25 da ff ff       	call   80103960 <myproc>
80105f3b:	8b 55 10             	mov    0x10(%ebp),%edx
80105f3e:	89 94 03 88 00 00 00 	mov    %edx,0x88(%ebx,%eax,1)
	((myproc()->allAddresses)[placeHolder]).refCount = 0;
80105f45:	e8 16 da ff ff       	call   80103960 <myproc>
80105f4a:	c7 84 03 4c 01 00 00 	movl   $0x0,0x14c(%ebx,%eax,1)
80105f51:	00 00 00 00 
	((myproc()->allAddresses)[placeHolder]).isPrivate = isPrivate;
80105f55:	e8 06 da ff ff       	call   80103960 <myproc>
80105f5a:	8b 55 14             	mov    0x14(%ebp),%edx
80105f5d:	89 94 03 50 01 00 00 	mov    %edx,0x150(%ebx,%eax,1)
	((myproc()->allAddresses)[placeHolder]).isAnonymous = isAnonymous;
80105f64:	e8 f7 d9 ff ff       	call   80103960 <myproc>
80105f69:	8b 55 18             	mov    0x18(%ebp),%edx
80105f6c:	89 94 03 54 01 00 00 	mov    %edx,0x154(%ebx,%eax,1)
	((myproc()->allAddresses)[placeHolder]).fd = fd;
80105f73:	e8 e8 d9 ff ff       	call   80103960 <myproc>
80105f78:	8b 55 1c             	mov    0x1c(%ebp),%edx
80105f7b:	89 94 03 58 01 00 00 	mov    %edx,0x158(%ebx,%eax,1)
	((myproc()->allAddresses)[placeHolder]).length = length;
80105f82:	e8 d9 d9 ff ff       	call   80103960 <myproc>
80105f87:	8b 55 20             	mov    0x20(%ebp),%edx
80105f8a:	89 94 03 60 01 00 00 	mov    %edx,0x160(%ebx,%eax,1)
	//((myproc()->allAddresses)[placeHolder]).ip = myproc()->ofile[(uint)(myproc()->allAddresses[placeHolder].fd)]->ip;
}
80105f91:	83 c4 2c             	add    $0x2c,%esp
80105f94:	5b                   	pop    %ebx
80105f95:	5e                   	pop    %esi
80105f96:	5f                   	pop    %edi
80105f97:	5d                   	pop    %ebp
80105f98:	c3                   	ret
80105f99:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for(int i=15; i>placeHolder; i--){
80105f9c:	83 7d d4 0e          	cmpl   $0xe,-0x2c(%ebp)
80105fa0:	0f 8e de fd ff ff    	jle    80105d84 <addAddress+0x74>
80105fa6:	e9 6f ff ff ff       	jmp    80105f1a <addAddress+0x20a>
80105fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105faf:	90                   	nop
			placeHolder = count + 1;
80105fb0:	83 c3 01             	add    $0x1,%ebx
80105fb3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
			break;
80105fb6:	eb e4                	jmp    80105f9c <addAddress+0x28c>
80105fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop

80105fc0 <sys_wmap>:

uint sys_wmap(void){
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
	int isAnonymous = 1;
	struct file *fd;

	// Retrieves the arguments that were passed into
	// the syscall
	if(argint(2, &flags) < 0 || argint(0, &expectedAddr) < 0 || argint(1, &length) < 0)
80105fc5:	8d 45 d8             	lea    -0x28(%ebp),%eax
uint sys_wmap(void){
80105fc8:	53                   	push   %ebx
80105fc9:	83 ec 34             	sub    $0x34,%esp
	if(argint(2, &flags) < 0 || argint(0, &expectedAddr) < 0 || argint(1, &length) < 0)
80105fcc:	50                   	push   %eax
80105fcd:	6a 02                	push   $0x2
80105fcf:	e8 cc ec ff ff       	call   80104ca0 <argint>
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	85 c0                	test   %eax,%eax
80105fd9:	0f 88 8e 00 00 00    	js     8010606d <sys_wmap+0xad>
80105fdf:	83 ec 08             	sub    $0x8,%esp
80105fe2:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fe5:	50                   	push   %eax
80105fe6:	6a 00                	push   $0x0
80105fe8:	e8 b3 ec ff ff       	call   80104ca0 <argint>
80105fed:	83 c4 10             	add    $0x10,%esp
80105ff0:	85 c0                	test   %eax,%eax
80105ff2:	78 79                	js     8010606d <sys_wmap+0xad>
80105ff4:	83 ec 08             	sub    $0x8,%esp
80105ff7:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ffa:	50                   	push   %eax
80105ffb:	6a 01                	push   $0x1
80105ffd:	e8 9e ec ff ff       	call   80104ca0 <argint>
80106002:	83 c4 10             	add    $0x10,%esp
80106005:	85 c0                	test   %eax,%eax
80106007:	78 64                	js     8010606d <sys_wmap+0xad>
		return FAILED;

	if((flags & MAP_ANONYMOUS) == 0){
80106009:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010600c:	89 fa                	mov    %edi,%edx
8010600e:	83 e2 04             	and    $0x4,%edx
80106011:	0f 84 31 01 00 00    	je     80106148 <sys_wmap+0x188>
			return FAILED;
		}
		isAnonymous = 0;
	}
	else{
		fd = NULL;
80106017:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int isAnonymous = 1;
8010601e:	ba 01 00 00 00       	mov    $0x1,%edx
	}
	
	// Makes sure that the address passed in is page aligned
	//cprintf("CURRENT: %x\n", length%4096);
	if(((flags & MAP_FIXED) == 8) && ((expectedAddr & 0xFFF) || ((uint)expectedAddr) < 0x60000000 || ((uint)expectedAddr) > 0x80000000)){
80106023:	f7 c7 08 00 00 00    	test   $0x8,%edi
80106029:	75 35                	jne    80106060 <sys_wmap+0xa0>

	if((flags & MAP_PRIVATE) == 1){
		isPrivate = 1;
	}
	// Figures out the amount of pages needed
	length = length;
8010602b:	8b 75 dc             	mov    -0x24(%ebp),%esi
	if((flags & MAP_PRIVATE) == 1){
8010602e:	83 e7 01             	and    $0x1,%edi
		if(goodAddress == 0){ // If not unused, will need to place in another address
			return FAILED;
		}
	}
	else{
		expectedAddr = 0;
80106031:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if((flags & MAP_PRIVATE) == 1){
80106038:	89 7d d4             	mov    %edi,-0x2c(%ebp)
	pages = (PGROUNDUP(length)) / 4096;
8010603b:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80106041:	c1 f8 0c             	sar    $0xc,%eax
80106044:	89 c1                	mov    %eax,%ecx
	uint checkedAddress = 0x60000000;
80106046:	89 55 d0             	mov    %edx,-0x30(%ebp)
	while(checkedAddress < 0x80000000){
80106049:	bf 00 00 00 60       	mov    $0x60000000,%edi
	uint checkedAddress = 0x60000000;
8010604e:	bb 00 00 00 60       	mov    $0x60000000,%ebx
80106053:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80106056:	eb 3c                	jmp    80106094 <sys_wmap+0xd4>
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop
	if(((flags & MAP_FIXED) == 8) && ((expectedAddr & 0xFFF) || ((uint)expectedAddr) < 0x60000000 || ((uint)expectedAddr) > 0x80000000)){
80106060:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106063:	89 55 d0             	mov    %edx,-0x30(%ebp)
80106066:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010606b:	74 6b                	je     801060d8 <sys_wmap+0x118>
		expectedAddr = findAvailableAddr(length); // Finds the next available address not being used
		//cprintf("NEW ADDRESS: %x\n", expectedAddr);
		addAddress(expectedAddr, expectedAddr + length, pages, isPrivate, isAnonymous, fd, length);
	}
	return expectedAddr;
}
8010606d:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return FAILED;
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106075:	5b                   	pop    %ebx
80106076:	5e                   	pop    %esi
80106077:	5f                   	pop    %edi
80106078:	5d                   	pop    %ebp
80106079:	c3                   	ret
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		checkedAddress += 4096;
80106080:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	while(checkedAddress < 0x80000000){
80106086:	89 df                	mov    %ebx,%edi
80106088:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
8010608e:	0f 84 dd 00 00 00    	je     80106171 <sys_wmap+0x1b1>
		foundValid = checkAddr(checkedAddress, checkedAddress+length);
80106094:	83 ec 08             	sub    $0x8,%esp
80106097:	8d 04 33             	lea    (%ebx,%esi,1),%eax
8010609a:	50                   	push   %eax
8010609b:	53                   	push   %ebx
8010609c:	e8 4f fb ff ff       	call   80105bf0 <checkAddr>
		if(foundValid == 1)
801060a1:	83 c4 10             	add    $0x10,%esp
801060a4:	83 f8 01             	cmp    $0x1,%eax
801060a7:	75 d7                	jne    80106080 <sys_wmap+0xc0>
		addAddress(expectedAddr, expectedAddr + length, pages, isPrivate, isAnonymous, fd, length);
801060a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
801060ac:	8b 4d cc             	mov    -0x34(%ebp),%ecx
801060af:	89 fb                	mov    %edi,%ebx
801060b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801060b4:	83 ec 04             	sub    $0x4,%esp
		expectedAddr = findAvailableAddr(length); // Finds the next available address not being used
801060b7:	89 7d e0             	mov    %edi,-0x20(%ebp)
		addAddress(expectedAddr, expectedAddr + length, pages, isPrivate, isAnonymous, fd, length);
801060ba:	50                   	push   %eax
801060bb:	01 f8                	add    %edi,%eax
801060bd:	ff 75 e4             	push   -0x1c(%ebp)
801060c0:	52                   	push   %edx
801060c1:	ff 75 d4             	push   -0x2c(%ebp)
801060c4:	51                   	push   %ecx
801060c5:	50                   	push   %eax
801060c6:	53                   	push   %ebx
801060c7:	e8 44 fc ff ff       	call   80105d10 <addAddress>
801060cc:	83 c4 20             	add    $0x20,%esp
801060cf:	eb 69                	jmp    8010613a <sys_wmap+0x17a>
801060d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if(((flags & MAP_FIXED) == 8) && ((expectedAddr & 0xFFF) || ((uint)expectedAddr) < 0x60000000 || ((uint)expectedAddr) > 0x80000000)){
801060d8:	8d 88 00 00 00 a0    	lea    -0x60000000(%eax),%ecx
801060de:	81 f9 00 00 00 20    	cmp    $0x20000000,%ecx
801060e4:	77 87                	ja     8010606d <sys_wmap+0xad>
	length = length;
801060e6:	8b 5d dc             	mov    -0x24(%ebp),%ebx
		goodAddress = checkAddr(expectedAddr, endingAddr); // Makes sure that the address is unused
801060e9:	83 ec 08             	sub    $0x8,%esp
	if((flags & MAP_PRIVATE) == 1){
801060ec:	83 e7 01             	and    $0x1,%edi
801060ef:	89 7d d4             	mov    %edi,-0x2c(%ebp)
	pages = (PGROUNDUP(length)) / 4096;
801060f2:	8d 8b ff 0f 00 00    	lea    0xfff(%ebx),%ecx
		endingAddr = expectedAddr + length; // Gets the ending address
801060f8:	01 c3                	add    %eax,%ebx
	pages = (PGROUNDUP(length)) / 4096;
801060fa:	c1 f9 0c             	sar    $0xc,%ecx
801060fd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		goodAddress = checkAddr(expectedAddr, endingAddr); // Makes sure that the address is unused
80106100:	53                   	push   %ebx
80106101:	50                   	push   %eax
80106102:	e8 e9 fa ff ff       	call   80105bf0 <checkAddr>
		if(goodAddress == 0){ // If not unused, will need to place in another address
80106107:	83 c4 10             	add    $0x10,%esp
8010610a:	85 c0                	test   %eax,%eax
8010610c:	0f 84 5b ff ff ff    	je     8010606d <sys_wmap+0xad>
	if(expectedAddr){
80106112:	8b 45 e0             	mov    -0x20(%ebp),%eax
		addAddress(expectedAddr, endingAddr, pages, isPrivate, isAnonymous, fd, length);
80106115:	8b 75 dc             	mov    -0x24(%ebp),%esi
	if(expectedAddr){
80106118:	8b 4d cc             	mov    -0x34(%ebp),%ecx
8010611b:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010611e:	85 c0                	test   %eax,%eax
80106120:	0f 84 20 ff ff ff    	je     80106046 <sys_wmap+0x86>
		addAddress(expectedAddr, endingAddr, pages, isPrivate, isAnonymous, fd, length);
80106126:	83 ec 04             	sub    $0x4,%esp
80106129:	56                   	push   %esi
8010612a:	ff 75 e4             	push   -0x1c(%ebp)
8010612d:	52                   	push   %edx
8010612e:	57                   	push   %edi
8010612f:	51                   	push   %ecx
80106130:	53                   	push   %ebx
80106131:	50                   	push   %eax
80106132:	e8 d9 fb ff ff       	call   80105d10 <addAddress>
80106137:	83 c4 20             	add    $0x20,%esp
	return expectedAddr;
8010613a:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
8010613d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106140:	5b                   	pop    %ebx
80106141:	5e                   	pop    %esi
80106142:	5f                   	pop    %edi
80106143:	5d                   	pop    %ebp
80106144:	c3                   	ret
80106145:	8d 76 00             	lea    0x0(%esi),%esi
		if(argfd(3, 0, &fd) < 0){
80106148:	83 ec 04             	sub    $0x4,%esp
8010614b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010614e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106151:	50                   	push   %eax
80106152:	6a 00                	push   $0x0
80106154:	6a 03                	push   $0x3
80106156:	e8 75 ee ff ff       	call   80104fd0 <argfd>
8010615b:	83 c4 10             	add    $0x10,%esp
8010615e:	85 c0                	test   %eax,%eax
80106160:	0f 88 07 ff ff ff    	js     8010606d <sys_wmap+0xad>
	if(((flags & MAP_FIXED) == 8) && ((expectedAddr & 0xFFF) || ((uint)expectedAddr) < 0x60000000 || ((uint)expectedAddr) > 0x80000000)){
80106166:	8b 7d d8             	mov    -0x28(%ebp),%edi
80106169:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010616c:	e9 b2 fe ff ff       	jmp    80106023 <sys_wmap+0x63>
80106171:	8b 55 d0             	mov    -0x30(%ebp),%edx
80106174:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80106177:	e9 35 ff ff ff       	jmp    801060b1 <sys_wmap+0xf1>
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106180 <removeMapping>:

void removeMapping(pde_t *pgdir, uint startAddr, int numPages, int found) {
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	57                   	push   %edi
80106184:	56                   	push   %esi
80106185:	53                   	push   %ebx
80106186:	83 ec 1c             	sub    $0x1c,%esp
    // Removing the entries from the process's page table (pgdir)
	uint a;
    pte_t *pte;

    for (a = startAddr; a < startAddr + numPages * PGSIZE; a += PGSIZE) {
80106189:	8b 5d 10             	mov    0x10(%ebp),%ebx
void removeMapping(pde_t *pgdir, uint startAddr, int numPages, int found) {
8010618c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010618f:	8b 75 08             	mov    0x8(%ebp),%esi
80106192:	8b 45 14             	mov    0x14(%ebp),%eax
    for (a = startAddr; a < startAddr + numPages * PGSIZE; a += PGSIZE) {
80106195:	c1 e3 0c             	shl    $0xc,%ebx
80106198:	01 fb                	add    %edi,%ebx
8010619a:	39 df                	cmp    %ebx,%edi
8010619c:	73 78                	jae    80106216 <removeMapping+0x96>
           for(int i=0; i<16; i++){
           	
           }

           struct proc *currproc = myproc();
        	if(currproc->allAddresses[found].refCount < 1)
8010619e:	69 c0 e8 00 00 00    	imul   $0xe8,%eax,%eax
801061a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061a7:	eb 11                	jmp    801061ba <removeMapping+0x3a>
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (a = startAddr; a < startAddr + numPages * PGSIZE; a += PGSIZE) {
801061b0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801061b6:	39 df                	cmp    %ebx,%edi
801061b8:	73 5c                	jae    80106216 <removeMapping+0x96>
        pte = (pte_t*)walkpgdir(pgdir, (char*)a, 0); //takes pgdir + starting va of each page + 0 makes it so it doesn't create a new pt if found
801061ba:	83 ec 04             	sub    $0x4,%esp
801061bd:	6a 00                	push   $0x0
801061bf:	57                   	push   %edi
801061c0:	56                   	push   %esi
801061c1:	e8 6a 1b 00 00       	call   80107d30 <walkpgdir>
        if (!pte){
801061c6:	83 c4 10             	add    $0x10,%esp
801061c9:	85 c0                	test   %eax,%eax
801061cb:	74 e3                	je     801061b0 <removeMapping+0x30>
        if (*pte & PTE_P) {
801061cd:	8b 08                	mov    (%eax),%ecx
801061cf:	f6 c1 01             	test   $0x1,%cl
801061d2:	74 dc                	je     801061b0 <removeMapping+0x30>
            if (pa == 0){
801061d4:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801061da:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801061dd:	74 4b                	je     8010622a <removeMapping+0xaa>
            *pte = 0;
801061df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
           struct proc *currproc = myproc();
801061e5:	e8 76 d7 ff ff       	call   80103960 <myproc>
        	if(currproc->allAddresses[found].refCount < 1)
801061ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
801061ed:	8b 84 02 4c 01 00 00 	mov    0x14c(%edx,%eax,1),%eax
801061f4:	85 c0                	test   %eax,%eax
801061f6:	7f b8                	jg     801061b0 <removeMapping+0x30>
            	kfree((char*)P2V(pa)); // convert pa to virtual (kernel space) before freeing
801061f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061fb:	83 ec 0c             	sub    $0xc,%esp
    for (a = startAddr; a < startAddr + numPages * PGSIZE; a += PGSIZE) {
801061fe:	81 c7 00 10 00 00    	add    $0x1000,%edi
            	kfree((char*)P2V(pa)); // convert pa to virtual (kernel space) before freeing
80106204:	05 00 00 00 80       	add    $0x80000000,%eax
80106209:	50                   	push   %eax
8010620a:	e8 91 c2 ff ff       	call   801024a0 <kfree>
8010620f:	83 c4 10             	add    $0x10,%esp
    for (a = startAddr; a < startAddr + numPages * PGSIZE; a += PGSIZE) {
80106212:	39 df                	cmp    %ebx,%edi
80106214:	72 a4                	jb     801061ba <removeMapping+0x3a>
        }
    }

    // switch to the new page directory to ensure changes are applied
    switchuvm(myproc());
80106216:	e8 45 d7 ff ff       	call   80103960 <myproc>
8010621b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010621e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106221:	5b                   	pop    %ebx
80106222:	5e                   	pop    %esi
80106223:	5f                   	pop    %edi
80106224:	5d                   	pop    %ebp
    switchuvm(myproc());
80106225:	e9 96 1c 00 00       	jmp    80107ec0 <switchuvm>
                panic("removeMapping: attempt to unmap an unmapped address");
8010622a:	83 ec 0c             	sub    $0xc,%esp
8010622d:	68 8c 8c 10 80       	push   $0x80108c8c
80106232:	e8 49 a1 ff ff       	call   80100380 <panic>
80106237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623e:	66 90                	xchg   %ax,%ax

80106240 <wunMap>:

int wunMap(uint addr, int flagRemovePhysicalMapping){
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	57                   	push   %edi
80106244:	56                   	push   %esi
	cprintf("ADDR: %x\n", addr);
	struct proc *currproc = myproc();
	int found = -1; 
	int i;
	for(i=0; i<16; i++){
80106245:	31 f6                	xor    %esi,%esi
int wunMap(uint addr, int flagRemovePhysicalMapping){
80106247:	53                   	push   %ebx
80106248:	83 ec 14             	sub    $0x14,%esp
8010624b:	8b 7d 08             	mov    0x8(%ebp),%edi
	cprintf("ADDR: %x\n", addr);
8010624e:	57                   	push   %edi
8010624f:	68 2e 8a 10 80       	push   $0x80108a2e
80106254:	e8 57 a4 ff ff       	call   801006b0 <cprintf>
	struct proc *currproc = myproc();
80106259:	e8 02 d7 ff ff       	call   80103960 <myproc>
8010625e:	83 c4 10             	add    $0x10,%esp
80106261:	89 c3                	mov    %eax,%ebx
	for(i=0; i<16; i++){
80106263:	8d 40 7c             	lea    0x7c(%eax),%eax
80106266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626d:	8d 76 00             	lea    0x0(%esi),%esi
		if(currproc->allAddresses[i].startingVirtualAddr == addr){
80106270:	39 38                	cmp    %edi,(%eax)
80106272:	74 1c                	je     80106290 <wunMap+0x50>
	for(i=0; i<16; i++){
80106274:	83 c6 01             	add    $0x1,%esi
80106277:	05 e8 00 00 00       	add    $0xe8,%eax
8010627c:	83 fe 10             	cmp    $0x10,%esi
8010627f:	75 ef                	jne    80106270 <wunMap+0x30>
	currproc->allAddresses[15].startingVirtualAddr = 0;
	currproc->allAddresses[15].endingVirtualAddr = 0;
	currproc->allAddresses[15].numberOfPages = 0;

	return SUCCESS;
}
80106281:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return FAILED; //mapping not found
80106284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106289:	5b                   	pop    %ebx
8010628a:	5e                   	pop    %esi
8010628b:	5f                   	pop    %edi
8010628c:	5d                   	pop    %ebp
8010628d:	c3                   	ret
8010628e:	66 90                	xchg   %ax,%ax
			cprintf("FOUND %d\n", i);
80106290:	83 ec 08             	sub    $0x8,%esp
80106293:	56                   	push   %esi
80106294:	68 38 8a 10 80       	push   $0x80108a38
80106299:	e8 12 a4 ff ff       	call   801006b0 <cprintf>
	if(flagRemovePhysicalMapping == 1){
8010629e:	83 c4 10             	add    $0x10,%esp
801062a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
801062a5:	74 61                	je     80106308 <wunMap+0xc8>
	for(; i<15; i++){
801062a7:	83 fe 0f             	cmp    $0xf,%esi
801062aa:	74 2d                	je     801062d9 <wunMap+0x99>
801062ac:	69 c6 e8 00 00 00    	imul   $0xe8,%esi,%eax
801062b2:	8d 93 98 0d 00 00    	lea    0xd98(%ebx),%edx
801062b8:	01 d8                	add    %ebx,%eax
801062ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		currproc->allAddresses[i] = currproc->allAddresses[i+1]; //move all other addr up
801062c0:	8d 78 7c             	lea    0x7c(%eax),%edi
801062c3:	8d b0 64 01 00 00    	lea    0x164(%eax),%esi
	for(; i<15; i++){
801062c9:	05 e8 00 00 00       	add    $0xe8,%eax
		currproc->allAddresses[i] = currproc->allAddresses[i+1]; //move all other addr up
801062ce:	b9 3a 00 00 00       	mov    $0x3a,%ecx
801062d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	for(; i<15; i++){
801062d5:	39 d0                	cmp    %edx,%eax
801062d7:	75 e7                	jne    801062c0 <wunMap+0x80>
	currproc->allAddresses[15].startingVirtualAddr = 0;
801062d9:	c7 83 14 0e 00 00 00 	movl   $0x0,0xe14(%ebx)
801062e0:	00 00 00 
	return SUCCESS;
801062e3:	31 c0                	xor    %eax,%eax
	currproc->allAddresses[15].endingVirtualAddr = 0;
801062e5:	c7 83 18 0e 00 00 00 	movl   $0x0,0xe18(%ebx)
801062ec:	00 00 00 
	currproc->allAddresses[15].numberOfPages = 0;
801062ef:	c7 83 20 0e 00 00 00 	movl   $0x0,0xe20(%ebx)
801062f6:	00 00 00 
}
801062f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062fc:	5b                   	pop    %ebx
801062fd:	5e                   	pop    %esi
801062fe:	5f                   	pop    %edi
801062ff:	5d                   	pop    %ebp
80106300:	c3                   	ret
80106301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		removeMapping(currproc->pgdir, currproc->allAddresses[found].startingVirtualAddr, currproc->allAddresses[found].numberOfPages, found);
80106308:	69 c6 e8 00 00 00    	imul   $0xe8,%esi,%eax
8010630e:	56                   	push   %esi
8010630f:	01 d8                	add    %ebx,%eax
80106311:	ff b0 88 00 00 00    	push   0x88(%eax)
80106317:	ff 70 7c             	push   0x7c(%eax)
8010631a:	ff 73 04             	push   0x4(%ebx)
8010631d:	e8 5e fe ff ff       	call   80106180 <removeMapping>
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	eb 80                	jmp    801062a7 <wunMap+0x67>
80106327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632e:	66 90                	xchg   %ax,%ax

80106330 <sys_wunmap>:

int sys_wunmap(void){
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 20             	sub    $0x20,%esp
	uint addr;
	//extract starting addr from syscall
	if(argint(0, (int*)&addr) < 0){
80106336:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106339:	50                   	push   %eax
8010633a:	6a 00                	push   $0x0
8010633c:	e8 5f e9 ff ff       	call   80104ca0 <argint>
80106341:	83 c4 10             	add    $0x10,%esp
80106344:	85 c0                	test   %eax,%eax
80106346:	78 30                	js     80106378 <sys_wunmap+0x48>
		return FAILED;
	}
	//ensure addr is page aligned
	if((addr & 0xFFF) != 0 || ((uint)addr) < 0x60000000 || ((uint)addr) > 0x80000000 || addr % PGSIZE != 0){
80106348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010634b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106350:	75 26                	jne    80106378 <sys_wunmap+0x48>
80106352:	8d 90 00 00 00 a0    	lea    -0x60000000(%eax),%edx
80106358:	81 fa 00 00 00 20    	cmp    $0x20000000,%edx
8010635e:	77 18                	ja     80106378 <sys_wunmap+0x48>
		return FAILED;
	}
	
	wunMap(addr, 1);
80106360:	83 ec 08             	sub    $0x8,%esp
80106363:	6a 01                	push   $0x1
80106365:	50                   	push   %eax
80106366:	e8 d5 fe ff ff       	call   80106240 <wunMap>

	return SUCCESS;
8010636b:	83 c4 10             	add    $0x10,%esp
8010636e:	31 c0                	xor    %eax,%eax
}
80106370:	c9                   	leave
80106371:	c3                   	ret
80106372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106378:	c9                   	leave
		return FAILED;
80106379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010637e:	c3                   	ret
8010637f:	90                   	nop

80106380 <isAdjacentSpaceFree>:

int isAdjacentSpaceFree(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex) {
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
    uint required_end_addr = oldaddr + newsize; //address where the new mapping would end
80106383:	8b 55 10             	mov    0x10(%ebp),%edx
80106386:	03 55 0c             	add    0xc(%ebp),%edx
int isAdjacentSpaceFree(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex) {
80106389:	8b 45 14             	mov    0x14(%ebp),%eax

    if(required_end_addr > 0x80000000){
8010638c:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
80106392:	77 2c                	ja     801063c0 <isAdjacentSpaceFree+0x40>
		return -1;
	}
	if(mappedIndex == 15){//required_end_addr is less than 0x80000000
		return 0;
80106394:	31 c9                	xor    %ecx,%ecx
	if(mappedIndex == 15){//required_end_addr is less than 0x80000000
80106396:	83 f8 0f             	cmp    $0xf,%eax
80106399:	74 17                	je     801063b2 <isAdjacentSpaceFree+0x32>
	}
	
	uint next_start_addr = currproc->allAddresses[mappedIndex+1].startingVirtualAddr;
8010639b:	83 c0 01             	add    $0x1,%eax
	if(next_start_addr != 0){//if index to right is mapped
		if(required_end_addr >= next_start_addr){
8010639e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	uint next_start_addr = currproc->allAddresses[mappedIndex+1].startingVirtualAddr;
801063a1:	69 c0 e8 00 00 00    	imul   $0xe8,%eax,%eax
		if(required_end_addr >= next_start_addr){
801063a7:	8b 44 01 7c          	mov    0x7c(%ecx,%eax,1),%eax
801063ab:	83 e8 01             	sub    $0x1,%eax
801063ae:	39 d0                	cmp    %edx,%eax
801063b0:	19 c9                	sbb    %ecx,%ecx
			return -1;
		}
	}

	return 0;
}
801063b2:	89 c8                	mov    %ecx,%eax
801063b4:	5d                   	pop    %ebp
801063b5:	c3                   	ret
801063b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063bd:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
801063c0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
801063c5:	eb eb                	jmp    801063b2 <isAdjacentSpaceFree+0x32>
801063c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ce:	66 90                	xchg   %ax,%ax

801063d0 <resizeMappingInPlace>:

void resizeMappingInPlace(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex, int isShrinking, uint oldEndAddr){
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	56                   	push   %esi
	uint required_end_addr = oldaddr + newsize; 
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
801063d4:	69 55 14 e8 00 00 00 	imul   $0xe8,0x14(%ebp),%edx
void resizeMappingInPlace(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex, int isShrinking, uint oldEndAddr){
801063db:	8b 45 10             	mov    0x10(%ebp),%eax
801063de:	53                   	push   %ebx
	uint required_end_addr = oldaddr + newsize; 
801063df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
void resizeMappingInPlace(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex, int isShrinking, uint oldEndAddr){
801063e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	uint required_end_addr = oldaddr + newsize; 
801063e5:	01 c3                	add    %eax,%ebx

	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
801063e7:	05 ff 0f 00 00       	add    $0xfff,%eax
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
801063ec:	01 ca                	add    %ecx,%edx
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
801063ee:	c1 f8 0c             	sar    $0xc,%eax
	if(isShrinking == 1){
801063f1:	83 7d 18 01          	cmpl   $0x1,0x18(%ebp)
	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
801063f5:	89 9a 80 00 00 00    	mov    %ebx,0x80(%edx)
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
801063fb:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
80106401:	8b b2 84 00 00 00    	mov    0x84(%edx),%esi
	if(isShrinking == 1){
80106407:	74 07                	je     80106410 <resizeMappingInPlace+0x40>
		if(oldEndAddr){}
		/*for(uint i=required_end_addr; i < oldEndAddr; i+=PGSIZE){
			wunMap(i, 1);
		}*/
	}
}
80106409:	5b                   	pop    %ebx
8010640a:	5e                   	pop    %esi
8010640b:	5d                   	pop    %ebp
8010640c:	c3                   	ret
8010640d:	8d 76 00             	lea    0x0(%esi),%esi
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
80106410:	29 c6                	sub    %eax,%esi
80106412:	89 5d 0c             	mov    %ebx,0xc(%ebp)
}
80106415:	5b                   	pop    %ebx
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
80106416:	89 75 10             	mov    %esi,0x10(%ebp)
}
80106419:	5e                   	pop    %esi
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
8010641a:	c7 45 14 01 00 00 00 	movl   $0x1,0x14(%ebp)
80106421:	8b 41 04             	mov    0x4(%ecx),%eax
80106424:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106427:	5d                   	pop    %ebp
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
80106428:	e9 53 fd ff ff       	jmp    80106180 <removeMapping>
8010642d:	8d 76 00             	lea    0x0(%esi),%esi

80106430 <allocateAdditionalPages>:

uint allocateAdditionalPages(struct proc *currproc, uint oldStartingAddr, int addition, int oldIndex) {
80106430:	55                   	push   %ebp
    int pagesNeeded = (PGROUNDUP(addition)) / PGSIZE;//store pagesNeeded

    //iterate through the virtual address space to find the first available address space
	for(int i=0; i< NELEM(currproc->allAddresses); i++){
80106431:	31 d2                	xor    %edx,%edx
uint allocateAdditionalPages(struct proc *currproc, uint oldStartingAddr, int addition, int oldIndex) {
80106433:	89 e5                	mov    %esp,%ebp
80106435:	57                   	push   %edi
80106436:	56                   	push   %esi
			availableLength = KERNBASE - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
		}else{
			//if [i] is mapped and [i+1] is mapped
			availableLength =  currproc->allAddresses[i+1].startingVirtualAddr - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
		}
		int availablePages = (PGROUNDUP(availableLength)) / PGSIZE;
80106437:	be ff ef ff 7f       	mov    $0x7fffefff,%esi
uint allocateAdditionalPages(struct proc *currproc, uint oldStartingAddr, int addition, int oldIndex) {
8010643c:	53                   	push   %ebx
8010643d:	83 ec 3c             	sub    $0x3c,%esp
    int pagesNeeded = (PGROUNDUP(addition)) / PGSIZE;//store pagesNeeded
80106440:	8b 45 10             	mov    0x10(%ebp),%eax
80106443:	05 ff 0f 00 00       	add    $0xfff,%eax
80106448:	c1 f8 0c             	sar    $0xc,%eax
8010644b:	89 c7                	mov    %eax,%edi
	for(int i=0; i< NELEM(currproc->allAddresses); i++){
8010644d:	8b 45 08             	mov    0x8(%ebp),%eax
80106450:	83 e8 80             	sub    $0xffffff80,%eax
80106453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106457:	90                   	nop
			availableLength =  currproc->allAddresses[i+1].startingVirtualAddr - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
80106458:	8b 18                	mov    (%eax),%ebx
		if(i == 15 || currproc->allAddresses[i+1].startingVirtualAddr == 0){
8010645a:	83 fa 0f             	cmp    $0xf,%edx
8010645d:	74 31                	je     80106490 <allocateAdditionalPages+0x60>
8010645f:	8b 88 e4 00 00 00    	mov    0xe4(%eax),%ecx
80106465:	85 c9                	test   %ecx,%ecx
80106467:	74 27                	je     80106490 <allocateAdditionalPages+0x60>
			availableLength =  currproc->allAddresses[i+1].startingVirtualAddr - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
80106469:	29 d9                	sub    %ebx,%ecx
		int availablePages = (PGROUNDUP(availableLength)) / PGSIZE;
8010646b:	81 e9 01 10 00 00    	sub    $0x1001,%ecx
80106471:	c1 f9 0c             	sar    $0xc,%ecx
		if(availablePages >= pagesNeeded){
80106474:	39 f9                	cmp    %edi,%ecx
80106476:	7d 48                	jge    801064c0 <allocateAdditionalPages+0x90>
	for(int i=0; i< NELEM(currproc->allAddresses); i++){
80106478:	83 c2 01             	add    $0x1,%edx
8010647b:	05 e8 00 00 00       	add    $0xe8,%eax
			availableLength =  currproc->allAddresses[i+1].startingVirtualAddr - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
80106480:	8b 18                	mov    (%eax),%ebx
		if(i == 15 || currproc->allAddresses[i+1].startingVirtualAddr == 0){
80106482:	83 fa 0f             	cmp    $0xf,%edx
80106485:	75 d8                	jne    8010645f <allocateAdditionalPages+0x2f>
80106487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010648e:	66 90                	xchg   %ax,%ax
		int availablePages = (PGROUNDUP(availableLength)) / PGSIZE;
80106490:	89 f1                	mov    %esi,%ecx
80106492:	29 d9                	sub    %ebx,%ecx
80106494:	c1 f9 0c             	sar    $0xc,%ecx
		if(availablePages >= pagesNeeded){
80106497:	39 cf                	cmp    %ecx,%edi
80106499:	7e 25                	jle    801064c0 <allocateAdditionalPages+0x90>
	for(int i=0; i< NELEM(currproc->allAddresses); i++){
8010649b:	83 c2 01             	add    $0x1,%edx
8010649e:	05 e8 00 00 00       	add    $0xe8,%eax
801064a3:	83 fa 10             	cmp    $0x10,%edx
801064a6:	75 b0                	jne    80106458 <allocateAdditionalPages+0x28>
		}
	}

	//space not found
    return FAILED;
}
801064a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
						return FAILED;
801064ab:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
}
801064b0:	5b                   	pop    %ebx
801064b1:	89 c8                	mov    %ecx,%eax
801064b3:	5e                   	pop    %esi
801064b4:	5f                   	pop    %edi
801064b5:	5d                   	pop    %ebp
801064b6:	c3                   	ret
801064b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064be:	66 90                	xchg   %ax,%ax
			uint endingAddr = startingAddr + addition;
801064c0:	8b 45 10             	mov    0x10(%ebp),%eax
			uint startingAddr = currproc->allAddresses[i].endingVirtualAddr + (1*PGSIZE);
801064c3:	8d 8b 00 10 00 00    	lea    0x1000(%ebx),%ecx
			uint endingAddr = startingAddr + addition;
801064c9:	89 7d c4             	mov    %edi,-0x3c(%ebp)
			int isPrivate = currproc->allAddresses[i].isPrivate;
801064cc:	69 da e8 00 00 00    	imul   $0xe8,%edx,%ebx
801064d2:	03 5d 08             	add    0x8(%ebp),%ebx
					if(mappages(myproc()->pgdir, (char*)currproc->allAddresses[j].startingVirtualAddr + i*PGSIZE, PGSIZE, currproc->allAddresses[i].forFork[j], PTE_W | PTE_U) < 0){ // The actual mapping of the pages
801064d5:	c1 e2 0c             	shl    $0xc,%edx
801064d8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
			uint endingAddr = startingAddr + addition;
801064db:	01 c8                	add    %ecx,%eax
					if(mappages(myproc()->pgdir, (char*)currproc->allAddresses[j].startingVirtualAddr + i*PGSIZE, PGSIZE, currproc->allAddresses[i].forFork[j], PTE_W | PTE_U) < 0){ // The actual mapping of the pages
801064dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			uint endingAddr = startingAddr + addition;
801064e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			int isPrivate = currproc->allAddresses[i].isPrivate;
801064e3:	8b 83 50 01 00 00    	mov    0x150(%ebx),%eax
801064e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			int isAnonymous = currproc->allAddresses[i].isAnonymous;
801064ec:	8b 83 54 01 00 00    	mov    0x154(%ebx),%eax
801064f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
			struct file* fd = currproc->allAddresses[i].fd;
801064f5:	8b 83 58 01 00 00    	mov    0x158(%ebx),%eax
801064fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			int length = currproc->allAddresses[i].length + addition;
801064fe:	8b 45 10             	mov    0x10(%ebp),%eax
80106501:	03 83 60 01 00 00    	add    0x160(%ebx),%eax
80106507:	89 45 c8             	mov    %eax,-0x38(%ebp)
			for(int j = 0; j < NELEM(currproc->allAddresses); j++){
8010650a:	8b 45 08             	mov    0x8(%ebp),%eax
8010650d:	8d 70 7c             	lea    0x7c(%eax),%esi
80106510:	8d 90 fc 0e 00 00    	lea    0xefc(%eax),%edx
80106516:	eb 15                	jmp    8010652d <allocateAdditionalPages+0xfd>
80106518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651f:	90                   	nop
80106520:	81 c6 e8 00 00 00    	add    $0xe8,%esi
80106526:	83 c3 04             	add    $0x4,%ebx
80106529:	39 d6                	cmp    %edx,%esi
8010652b:	74 63                	je     80106590 <allocateAdditionalPages+0x160>
				if(currproc->allAddresses[i].forFork[j] != 0){
8010652d:	8b bb 0c 01 00 00    	mov    0x10c(%ebx),%edi
80106533:	85 ff                	test   %edi,%edi
80106535:	74 e9                	je     80106520 <allocateAdditionalPages+0xf0>
					if(mappages(myproc()->pgdir, (char*)currproc->allAddresses[j].startingVirtualAddr + i*PGSIZE, PGSIZE, currproc->allAddresses[i].forFork[j], PTE_W | PTE_U) < 0){ // The actual mapping of the pages
80106537:	8b 4d dc             	mov    -0x24(%ebp),%ecx
8010653a:	03 0e                	add    (%esi),%ecx
8010653c:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010653f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106542:	e8 19 d4 ff ff       	call   80103960 <myproc>
80106547:	83 ec 0c             	sub    $0xc,%esp
8010654a:	6a 06                	push   $0x6
8010654c:	57                   	push   %edi
8010654d:	68 00 10 00 00       	push   $0x1000
80106552:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106555:	51                   	push   %ecx
80106556:	ff 70 04             	push   0x4(%eax)
80106559:	e8 62 18 00 00       	call   80107dc0 <mappages>
8010655e:	83 c4 20             	add    $0x20,%esp
80106561:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106564:	85 c0                	test   %eax,%eax
80106566:	79 b8                	jns    80106520 <allocateAdditionalPages+0xf0>
						cprintf("mappages() not working\n");
80106568:	83 ec 0c             	sub    $0xc,%esp
8010656b:	68 42 8a 10 80       	push   $0x80108a42
80106570:	e8 3b a1 ff ff       	call   801006b0 <cprintf>
						myproc()->killed = 1;
80106575:	e8 e6 d3 ff ff       	call   80103960 <myproc>
						return FAILED;
8010657a:	83 c4 10             	add    $0x10,%esp
						myproc()->killed = 1;
8010657d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
						return FAILED;
80106584:	e9 1f ff ff ff       	jmp    801064a8 <allocateAdditionalPages+0x78>
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			wunMap(oldStartingAddr, 0);
80106590:	8b 4d c0             	mov    -0x40(%ebp),%ecx
80106593:	83 ec 08             	sub    $0x8,%esp
80106596:	8b 7d c4             	mov    -0x3c(%ebp),%edi
80106599:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010659c:	6a 00                	push   $0x0
8010659e:	ff 75 0c             	push   0xc(%ebp)
801065a1:	e8 9a fc ff ff       	call   80106240 <wunMap>
			addAddress(startingAddr, endingAddr, pagesNeeded, isPrivate, isAnonymous, fd, length);
801065a6:	83 c4 0c             	add    $0xc,%esp
801065a9:	ff 75 c8             	push   -0x38(%ebp)
801065ac:	ff 75 cc             	push   -0x34(%ebp)
801065af:	ff 75 d0             	push   -0x30(%ebp)
801065b2:	ff 75 d4             	push   -0x2c(%ebp)
801065b5:	57                   	push   %edi
801065b6:	ff 75 d8             	push   -0x28(%ebp)
801065b9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801065bc:	51                   	push   %ecx
801065bd:	e8 4e f7 ff ff       	call   80105d10 <addAddress>
			return startingAddr;
801065c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801065c5:	83 c4 20             	add    $0x20,%esp
}
801065c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065cb:	5b                   	pop    %ebx
801065cc:	5e                   	pop    %esi
801065cd:	89 c8                	mov    %ecx,%eax
801065cf:	5f                   	pop    %edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret
801065d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065e0 <sys_wremap>:

uint sys_wremap(void){
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
    int oldsize, newsize, flags;
	uint resultStartingAddr = FAILED;
	
	
    // Extract arguments from syscall
    if (argint(0, (int*)&oldaddr) < 0 || argint(1, &oldsize) < 0 || argint(2, &newsize) < 0 || argint(3, &flags) < 0){
801065e5:	8d 45 d8             	lea    -0x28(%ebp),%eax
uint sys_wremap(void){
801065e8:	53                   	push   %ebx
801065e9:	83 ec 34             	sub    $0x34,%esp
    if (argint(0, (int*)&oldaddr) < 0 || argint(1, &oldsize) < 0 || argint(2, &newsize) < 0 || argint(3, &flags) < 0){
801065ec:	50                   	push   %eax
801065ed:	6a 00                	push   $0x0
801065ef:	e8 ac e6 ff ff       	call   80104ca0 <argint>
801065f4:	83 c4 10             	add    $0x10,%esp
801065f7:	85 c0                	test   %eax,%eax
801065f9:	0f 88 19 01 00 00    	js     80106718 <sys_wremap+0x138>
801065ff:	83 ec 08             	sub    $0x8,%esp
80106602:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106605:	50                   	push   %eax
80106606:	6a 01                	push   $0x1
80106608:	e8 93 e6 ff ff       	call   80104ca0 <argint>
8010660d:	83 c4 10             	add    $0x10,%esp
80106610:	85 c0                	test   %eax,%eax
80106612:	0f 88 00 01 00 00    	js     80106718 <sys_wremap+0x138>
80106618:	83 ec 08             	sub    $0x8,%esp
8010661b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010661e:	50                   	push   %eax
8010661f:	6a 02                	push   $0x2
80106621:	e8 7a e6 ff ff       	call   80104ca0 <argint>
80106626:	83 c4 10             	add    $0x10,%esp
80106629:	85 c0                	test   %eax,%eax
8010662b:	0f 88 e7 00 00 00    	js     80106718 <sys_wremap+0x138>
80106631:	83 ec 08             	sub    $0x8,%esp
80106634:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106637:	50                   	push   %eax
80106638:	6a 03                	push   $0x3
8010663a:	e8 61 e6 ff ff       	call   80104ca0 <argint>
8010663f:	83 c4 10             	add    $0x10,%esp
80106642:	85 c0                	test   %eax,%eax
80106644:	0f 88 ce 00 00 00    	js     80106718 <sys_wremap+0x138>
        cprintf("failed arguments");
		return FAILED;
	}
	
    // Validate inputs, e.g., page alignment, size > 0
    if (oldaddr % PGSIZE != 0 || newsize <= 0){
8010664a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010664d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106650:	25 ff 0f 00 00       	and    $0xfff,%eax
80106655:	0f 85 35 01 00 00    	jne    80106790 <sys_wremap+0x1b0>
8010665b:	85 d2                	test   %edx,%edx
8010665d:	0f 8e 2d 01 00 00    	jle    80106790 <sys_wremap+0x1b0>
		return FAILED;
	}

    //wremap logic here
    // 1. Check if oldaddr and oldsize match an existing mapping
	struct proc *currproc = myproc();
80106663:	e8 f8 d2 ff ff       	call   80103960 <myproc>
	int mappedIndex = -1;
	for (int i = 0; i < NELEM(currproc->allAddresses); i++) {
80106668:	31 db                	xor    %ebx,%ebx
	struct proc *currproc = myproc();
8010666a:	89 c6                	mov    %eax,%esi
		//uint currprocSize = currproc->allAddresses[i].endingVirtualAddr - currproc->allAddresses[i].startingVirtualAddr;
		//cprintf("INDEX: %d currproc->allAddresses[i].startingVirtualAddr: %x oldaddr: %x\n", i, currproc->allAddresses[i].startingVirtualAddr, oldaddr);
		if (currproc->allAddresses[i].startingVirtualAddr == oldaddr) {
8010666c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010666f:	8d 4e 7c             	lea    0x7c(%esi),%ecx
80106672:	89 c2                	mov    %eax,%edx
80106674:	eb 1c                	jmp    80106692 <sys_wremap+0xb2>
80106676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667d:	8d 76 00             	lea    0x0(%esi),%esi
	for (int i = 0; i < NELEM(currproc->allAddresses); i++) {
80106680:	83 c3 01             	add    $0x1,%ebx
80106683:	81 c1 e8 00 00 00    	add    $0xe8,%ecx
80106689:	83 fb 10             	cmp    $0x10,%ebx
8010668c:	0f 84 96 00 00 00    	je     80106728 <sys_wremap+0x148>
		if (currproc->allAddresses[i].startingVirtualAddr == oldaddr) {
80106692:	39 01                	cmp    %eax,(%ecx)
80106694:	75 ea                	jne    80106680 <sys_wremap+0xa0>
	if (mappedIndex == -1) return FAILED; // No matching mapping found

	uint oldEndAddr = currproc->allAddresses[mappedIndex].endingVirtualAddr;

    // 2. Attempt in-place resize if flags == 0
	if (flags == 0 && newsize > oldsize) {
80106696:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106699:	85 c9                	test   %ecx,%ecx
8010669b:	0f 84 9f 00 00 00    	je     80106740 <sys_wremap+0x160>
	uint resultStartingAddr = FAILED;
801066a1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
		resultStartingAddr = oldaddr;
	}


    // 3. If in-place resize fails and MREMAP_MAYMOVE is set, attempt to move
	if ((flags & MREMAP_MAYMOVE) && newsize > oldsize) {
801066a6:	83 e1 01             	and    $0x1,%ecx
801066a9:	74 5e                	je     80106709 <sys_wremap+0x129>
801066ab:	8b 7d e0             	mov    -0x20(%ebp),%edi
801066ae:	89 7d d4             	mov    %edi,-0x2c(%ebp)
801066b1:	3b 7d dc             	cmp    -0x24(%ebp),%edi
801066b4:	0f 8e 46 01 00 00    	jle    80106800 <sys_wremap+0x220>
    uint required_end_addr = oldaddr + newsize; //address where the new mapping would end
801066ba:	01 c7                	add    %eax,%edi
		//allocate additional pages and update the mapping's end address
		if(isAdjacentSpaceFree(currproc, oldaddr, newsize, mappedIndex) == -1) {
801066bc:	89 c2                	mov    %eax,%edx
    uint required_end_addr = oldaddr + newsize; //address where the new mapping would end
801066be:	89 f9                	mov    %edi,%ecx
    if(required_end_addr > 0x80000000){
801066c0:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
801066c6:	0f 87 7d 01 00 00    	ja     80106849 <sys_wremap+0x269>
	if(mappedIndex == 15){//required_end_addr is less than 0x80000000
801066cc:	83 fb 0f             	cmp    $0xf,%ebx
801066cf:	74 18                	je     801066e9 <sys_wremap+0x109>
	uint next_start_addr = currproc->allAddresses[mappedIndex+1].startingVirtualAddr;
801066d1:	8d 7b 01             	lea    0x1(%ebx),%edi
801066d4:	69 ff e8 00 00 00    	imul   $0xe8,%edi,%edi
		if(required_end_addr >= next_start_addr){
801066da:	8b 7c 3e 7c          	mov    0x7c(%esi,%edi,1),%edi
801066de:	83 ef 01             	sub    $0x1,%edi
801066e1:	39 cf                	cmp    %ecx,%edi
801066e3:	0f 82 60 01 00 00    	jb     80106849 <sys_wremap+0x269>
	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
801066e9:	69 db e8 00 00 00    	imul   $0xe8,%ebx,%ebx
801066ef:	01 f3                	add    %esi,%ebx
801066f1:	89 8b 80 00 00 00    	mov    %ecx,0x80(%ebx)
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
801066f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
801066fa:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
80106700:	c1 f9 0c             	sar    $0xc,%ecx
80106703:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
		resizeMappingInPlace(currproc, oldaddr, newsize, mappedIndex, 1, oldEndAddr);
		resultStartingAddr = oldaddr;
	}

	return resultStartingAddr;
}
80106709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010670c:	89 d0                	mov    %edx,%eax
8010670e:	5b                   	pop    %ebx
8010670f:	5e                   	pop    %esi
80106710:	5f                   	pop    %edi
80106711:	5d                   	pop    %ebp
80106712:	c3                   	ret
80106713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106717:	90                   	nop
        cprintf("failed arguments");
80106718:	83 ec 0c             	sub    $0xc,%esp
8010671b:	68 5a 8a 10 80       	push   $0x80108a5a
80106720:	e8 8b 9f ff ff       	call   801006b0 <cprintf>
		return FAILED;
80106725:	83 c4 10             	add    $0x10,%esp
}
80106728:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return FAILED;
8010672b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80106730:	5b                   	pop    %ebx
80106731:	89 d0                	mov    %edx,%eax
80106733:	5e                   	pop    %esi
80106734:	5f                   	pop    %edi
80106735:	5d                   	pop    %ebp
80106736:	c3                   	ret
80106737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010673e:	66 90                	xchg   %ax,%ax
	if (flags == 0 && newsize > oldsize) {
80106740:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106743:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
80106746:	7e 60                	jle    801067a8 <sys_wremap+0x1c8>
    uint required_end_addr = oldaddr + newsize; //address where the new mapping would end
80106748:	01 c8                	add    %ecx,%eax
    if(required_end_addr > 0x80000000){
8010674a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010674f:	77 d7                	ja     80106728 <sys_wremap+0x148>
	if(mappedIndex == 15){//required_end_addr is less than 0x80000000
80106751:	83 fb 0f             	cmp    $0xf,%ebx
80106754:	74 14                	je     8010676a <sys_wremap+0x18a>
	uint next_start_addr = currproc->allAddresses[mappedIndex+1].startingVirtualAddr;
80106756:	8d 7b 01             	lea    0x1(%ebx),%edi
80106759:	69 ff e8 00 00 00    	imul   $0xe8,%edi,%edi
		if(required_end_addr >= next_start_addr){
8010675f:	8b 7c 3e 7c          	mov    0x7c(%esi,%edi,1),%edi
80106763:	83 ef 01             	sub    $0x1,%edi
80106766:	39 c7                	cmp    %eax,%edi
80106768:	72 be                	jb     80106728 <sys_wremap+0x148>
	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
8010676a:	69 db e8 00 00 00    	imul   $0xe8,%ebx,%ebx
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
80106770:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
80106776:	c1 f9 0c             	sar    $0xc,%ecx
	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
80106779:	01 f3                	add    %esi,%ebx
8010677b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
80106781:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
		resultStartingAddr = oldaddr;
80106787:	eb 80                	jmp    80106709 <sys_wremap+0x129>
80106789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		cprintf("invalid inputs: oldaddr / PGSIZE = %x && newsize = %d", oldaddr % PGSIZE, newsize);
80106790:	83 ec 04             	sub    $0x4,%esp
80106793:	52                   	push   %edx
80106794:	50                   	push   %eax
80106795:	68 c0 8c 10 80       	push   $0x80108cc0
8010679a:	e8 11 9f ff ff       	call   801006b0 <cprintf>
		return FAILED;
8010679f:	83 c4 10             	add    $0x10,%esp
801067a2:	eb 84                	jmp    80106728 <sys_wremap+0x148>
801067a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	uint resultStartingAddr = FAILED;
801067a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	}else if (flags == 0 && newsize < oldsize){//shrink
801067ad:	0f 8d 56 ff ff ff    	jge    80106709 <sys_wremap+0x129>
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
801067b3:	69 d3 e8 00 00 00    	imul   $0xe8,%ebx,%edx
	uint required_end_addr = oldaddr + newsize; 
801067b9:	01 c8                	add    %ecx,%eax
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
801067bb:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
801067c1:	c1 f9 0c             	sar    $0xc,%ecx
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
801067c4:	01 f2                	add    %esi,%edx
801067c6:	8b ba 84 00 00 00    	mov    0x84(%edx),%edi
	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
801067cc:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
801067d2:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
801067d8:	29 cf                	sub    %ecx,%edi
801067da:	6a 01                	push   $0x1
801067dc:	57                   	push   %edi
801067dd:	50                   	push   %eax
801067de:	ff 76 04             	push   0x4(%esi)
801067e1:	e8 9a f9 ff ff       	call   80106180 <removeMapping>
		resultStartingAddr = oldaddr;
801067e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
	if ((flags & MREMAP_MAYMOVE) && newsize > oldsize) {
801067e9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801067ec:	83 c4 10             	add    $0x10,%esp
		resultStartingAddr = oldaddr;
801067ef:	89 c2                	mov    %eax,%edx
801067f1:	e9 b0 fe ff ff       	jmp    801066a6 <sys_wremap+0xc6>
801067f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067fd:	8d 76 00             	lea    0x0(%esi),%esi
	}else if((flags & MREMAP_MAYMOVE) && newsize < oldsize){//shrinking
80106800:	0f 8d 03 ff ff ff    	jge    80106709 <sys_wremap+0x129>
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
80106806:	69 d3 e8 00 00 00    	imul   $0xe8,%ebx,%edx
	uint required_end_addr = oldaddr + newsize; 
8010680c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
8010680f:	01 f8                	add    %edi,%eax
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
80106811:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
80106817:	01 f2                	add    %esi,%edx
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
80106819:	89 f9                	mov    %edi,%ecx
	int tempPages = currproc->allAddresses[mappedIndex].physicalPageNumber;
8010681b:	8b 9a 84 00 00 00    	mov    0x84(%edx),%ebx
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
80106821:	c1 f9 0c             	sar    $0xc,%ecx
	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
80106824:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
8010682a:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
80106830:	29 cb                	sub    %ecx,%ebx
80106832:	6a 01                	push   $0x1
80106834:	53                   	push   %ebx
80106835:	50                   	push   %eax
80106836:	ff 76 04             	push   0x4(%esi)
80106839:	e8 42 f9 ff ff       	call   80106180 <removeMapping>
		resultStartingAddr = oldaddr;
8010683e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106841:	83 c4 10             	add    $0x10,%esp
80106844:	e9 c0 fe ff ff       	jmp    80106709 <sys_wremap+0x129>
			resultStartingAddr = allocateAdditionalPages(currproc, oldaddr, newsize, mappedIndex);
80106849:	53                   	push   %ebx
8010684a:	ff 75 d4             	push   -0x2c(%ebp)
8010684d:	50                   	push   %eax
8010684e:	56                   	push   %esi
8010684f:	e8 dc fb ff ff       	call   80106430 <allocateAdditionalPages>
80106854:	83 c4 10             	add    $0x10,%esp
80106857:	89 c2                	mov    %eax,%edx
80106859:	e9 ab fe ff ff       	jmp    80106709 <sys_wremap+0x129>
8010685e:	66 90                	xchg   %ax,%ax

80106860 <sys_getwmapinfo>:

int sys_getwmapinfo(void){
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
80106866:	83 ec 1c             	sub    $0x1c,%esp
	struct wmapinfo *wminfo;
    struct proc *currproc = myproc();
80106869:	e8 f2 d0 ff ff       	call   80103960 <myproc>
	int count = 0;
	
	//check if arg is a pointer to wmapinfo struct from user space
    if(argptr(0, (void*)&wminfo, sizeof(*wminfo)) < 0){
8010686e:	83 ec 04             	sub    $0x4,%esp
    struct proc *currproc = myproc();
80106871:	89 c3                	mov    %eax,%ebx
    if(argptr(0, (void*)&wminfo, sizeof(*wminfo)) < 0){
80106873:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106876:	68 c4 00 00 00       	push   $0xc4
8010687b:	50                   	push   %eax
8010687c:	6a 00                	push   $0x0
8010687e:	e8 6d e4 ff ff       	call   80104cf0 <argptr>
80106883:	83 c4 10             	add    $0x10,%esp
80106886:	85 c0                	test   %eax,%eax
80106888:	78 58                	js     801068e2 <sys_getwmapinfo+0x82>
		return FAILED;
	}

    for (int i = 0; i < MAX_WMMAP_INFO && i < NELEM(currproc->allAddresses); i++) {
        if (currproc->allAddresses[i].startingVirtualAddr >= 0x60000000 && currproc->allAddresses[i].endingVirtualAddr <= 0x80000000) { //check that this is a mapped index
            wminfo->addr[count] = currproc->allAddresses[i].startingVirtualAddr;//starting addr of mapping
8010688a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010688d:	8d 43 7c             	lea    0x7c(%ebx),%eax
80106890:	8d 8b fc 0e 00 00    	lea    0xefc(%ebx),%ecx
	int count = 0;
80106896:	31 f6                	xor    %esi,%esi
80106898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689f:	90                   	nop
        if (currproc->allAddresses[i].startingVirtualAddr >= 0x60000000 && currproc->allAddresses[i].endingVirtualAddr <= 0x80000000) { //check that this is a mapped index
801068a0:	8b 10                	mov    (%eax),%edx
801068a2:	81 fa ff ff ff 5f    	cmp    $0x5fffffff,%edx
801068a8:	76 23                	jbe    801068cd <sys_getwmapinfo+0x6d>
801068aa:	81 78 04 00 00 00 80 	cmpl   $0x80000000,0x4(%eax)
801068b1:	77 1a                	ja     801068cd <sys_getwmapinfo+0x6d>
            wminfo->addr[count] = currproc->allAddresses[i].startingVirtualAddr;//starting addr of mapping
801068b3:	8d 1c b7             	lea    (%edi,%esi,4),%ebx
            wminfo->length[count] = currproc->allAddresses[i].endingVirtualAddr - currproc->allAddresses[i].startingVirtualAddr;//size of mapping
            wminfo->n_loaded_pages[count] = currproc->allAddresses[i].physicalPageNumber;//count how many page loaded
            count++;
801068b6:	83 c6 01             	add    $0x1,%esi
            wminfo->addr[count] = currproc->allAddresses[i].startingVirtualAddr;//starting addr of mapping
801068b9:	89 53 04             	mov    %edx,0x4(%ebx)
            wminfo->length[count] = currproc->allAddresses[i].endingVirtualAddr - currproc->allAddresses[i].startingVirtualAddr;//size of mapping
801068bc:	8b 50 04             	mov    0x4(%eax),%edx
801068bf:	2b 10                	sub    (%eax),%edx
801068c1:	89 53 44             	mov    %edx,0x44(%ebx)
            wminfo->n_loaded_pages[count] = currproc->allAddresses[i].physicalPageNumber;//count how many page loaded
801068c4:	8b 50 08             	mov    0x8(%eax),%edx
801068c7:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
    for (int i = 0; i < MAX_WMMAP_INFO && i < NELEM(currproc->allAddresses); i++) {
801068cd:	05 e8 00 00 00       	add    $0xe8,%eax
801068d2:	39 c8                	cmp    %ecx,%eax
801068d4:	75 ca                	jne    801068a0 <sys_getwmapinfo+0x40>
        }
    }
    wminfo->total_mmaps = count; //total num of wmap regions
801068d6:	89 37                	mov    %esi,(%edi)
    return SUCCESS;
801068d8:	31 c0                	xor    %eax,%eax
}
801068da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068dd:	5b                   	pop    %ebx
801068de:	5e                   	pop    %esi
801068df:	5f                   	pop    %edi
801068e0:	5d                   	pop    %ebp
801068e1:	c3                   	ret
		return FAILED;
801068e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e7:	eb f1                	jmp    801068da <sys_getwmapinfo+0x7a>
801068e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068f0 <sys_getpgdirinfo>:

int sys_getpgdirinfo(void){
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
801068f6:	83 ec 2c             	sub    $0x2c,%esp
	struct proc *currproc = myproc();
801068f9:	e8 62 d0 ff ff       	call   80103960 <myproc>
	pde_t *pgdir = currproc->pgdir;
	int count = 0;
	struct pgdirinfo *pginfo;
	int inChar = 0;

	if(argptr(0, (void*)&pginfo, sizeof(*pginfo)) < 0)
801068fe:	83 ec 04             	sub    $0x4,%esp
	pde_t *pgdir = currproc->pgdir;
80106901:	8b 70 04             	mov    0x4(%eax),%esi
	if(argptr(0, (void*)&pginfo, sizeof(*pginfo)) < 0)
80106904:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106907:	68 04 01 00 00       	push   $0x104
8010690c:	50                   	push   %eax
8010690d:	6a 00                	push   $0x0
8010690f:	e8 dc e3 ff ff       	call   80104cf0 <argptr>
80106914:	83 c4 10             	add    $0x10,%esp
80106917:	85 c0                	test   %eax,%eax
80106919:	0f 88 80 00 00 00    	js     8010699f <sys_getpgdirinfo+0xaf>
	int inChar = 0;
8010691f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		return FAILED;

	pte_t *pte;
	uint a = 0;
80106926:	31 ff                	xor    %edi,%edi
	int count = 0;
80106928:	31 db                	xor    %ebx,%ebx
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	
	for(;a < KERNBASE; a=PGROUNDDOWN(a+PGSIZE)){
		pte = (pte_t*)walkpgdir(pgdir, (char*)a, 0);
80106930:	83 ec 04             	sub    $0x4,%esp
80106933:	6a 00                	push   $0x0
80106935:	57                   	push   %edi
80106936:	56                   	push   %esi
80106937:	e8 f4 13 00 00       	call   80107d30 <walkpgdir>
		
		if (!pte){
8010693c:	83 c4 10             	add    $0x10,%esp
8010693f:	85 c0                	test   %eax,%eax
80106941:	74 09                	je     8010694c <sys_getpgdirinfo+0x5c>
            continue; // no entry, move to next page			            
		}
		
		if((*pte & PTE_P) && (*pte & PTE_U)){
80106943:	8b 10                	mov    (%eax),%edx
80106945:	f7 d2                	not    %edx
80106947:	83 e2 05             	and    $0x5,%edx
8010694a:	74 24                	je     80106970 <sys_getpgdirinfo+0x80>
	for(;a < KERNBASE; a=PGROUNDDOWN(a+PGSIZE)){
8010694c:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106952:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
80106958:	75 d6                	jne    80106930 <sys_getpgdirinfo+0x40>
				inChar++;
			}
		}
	}
	
	pginfo->n_upages = count;
8010695a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010695d:	89 18                	mov    %ebx,(%eax)
	return SUCCESS;
8010695f:	31 c0                	xor    %eax,%eax
}
80106961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106964:	5b                   	pop    %ebx
80106965:	5e                   	pop    %esi
80106966:	5f                   	pop    %edi
80106967:	5d                   	pop    %ebp
80106968:	c3                   	ret
80106969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			pginfo->va[count] = 0;
80106970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			count++;
80106973:	83 c3 01             	add    $0x1,%ebx
			if(a >= 0x60000000 && a <= 0x80000000){
80106976:	8d 8f 00 00 00 a0    	lea    -0x60000000(%edi),%ecx
			pginfo->va[count] = 0;
8010697c:	c7 44 9a 04 00 00 00 	movl   $0x0,0x4(%edx,%ebx,4)
80106983:	00 
			pginfo->pa[count] = 0;
80106984:	c7 84 9a 84 00 00 00 	movl   $0x0,0x84(%edx,%ebx,4)
8010698b:	00 00 00 00 
			if(a >= 0x60000000 && a <= 0x80000000){
8010698f:	81 f9 00 00 00 20    	cmp    $0x20000000,%ecx
80106995:	76 0f                	jbe    801069a6 <sys_getpgdirinfo+0xb6>
	for(;a < KERNBASE; a=PGROUNDDOWN(a+PGSIZE)){
80106997:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010699d:	eb 91                	jmp    80106930 <sys_getpgdirinfo+0x40>
		return FAILED;
8010699f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a4:	eb bb                	jmp    80106961 <sys_getpgdirinfo+0x71>
			uint pa = PTE_ADDR(*pte);
801069a6:	8b 00                	mov    (%eax),%eax
				pginfo->va[inChar] = a;
801069a8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			uint pa = PTE_ADDR(*pte);
801069ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
				pginfo->va[inChar] = a;
801069b0:	89 7c 8a 04          	mov    %edi,0x4(%edx,%ecx,4)
			uint pa = PTE_ADDR(*pte);
801069b4:	89 84 8a 84 00 00 00 	mov    %eax,0x84(%edx,%ecx,4)
				inChar++;
801069bb:	83 c1 01             	add    $0x1,%ecx
801069be:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
801069c1:	eb 89                	jmp    8010694c <sys_getpgdirinfo+0x5c>

801069c3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801069c3:	1e                   	push   %ds
  pushl %es
801069c4:	06                   	push   %es
  pushl %fs
801069c5:	0f a0                	push   %fs
  pushl %gs
801069c7:	0f a8                	push   %gs
  pushal
801069c9:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801069ca:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801069ce:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801069d0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801069d2:	54                   	push   %esp
  call trap
801069d3:	e8 58 01 00 00       	call   80106b30 <trap>
  addl $4, %esp
801069d8:	83 c4 04             	add    $0x4,%esp

801069db <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801069db:	61                   	popa
  popl %gs
801069dc:	0f a9                	pop    %gs
  popl %fs
801069de:	0f a1                	pop    %fs
  popl %es
801069e0:	07                   	pop    %es
  popl %ds
801069e1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801069e2:	83 c4 08             	add    $0x8,%esp
  iret
801069e5:	cf                   	iret
801069e6:	66 90                	xchg   %ax,%ax
801069e8:	66 90                	xchg   %ax,%ax
801069ea:	66 90                	xchg   %ax,%ax
801069ec:	66 90                	xchg   %ax,%ax
801069ee:	66 90                	xchg   %ax,%ax

801069f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801069f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801069f1:	31 c0                	xor    %eax,%eax
{
801069f3:	89 e5                	mov    %esp,%ebp
801069f5:	83 ec 08             	sub    $0x8,%esp
801069f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106a00:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106a07:	c7 04 c5 c2 fc 14 80 	movl   $0x8e000008,-0x7feb033e(,%eax,8)
80106a0e:	08 00 00 8e 
80106a12:	66 89 14 c5 c0 fc 14 	mov    %dx,-0x7feb0340(,%eax,8)
80106a19:	80 
80106a1a:	c1 ea 10             	shr    $0x10,%edx
80106a1d:	66 89 14 c5 c6 fc 14 	mov    %dx,-0x7feb033a(,%eax,8)
80106a24:	80 
  for(i = 0; i < 256; i++)
80106a25:	83 c0 01             	add    $0x1,%eax
80106a28:	3d 00 01 00 00       	cmp    $0x100,%eax
80106a2d:	75 d1                	jne    80106a00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106a2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a32:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106a37:	c7 05 c2 fe 14 80 08 	movl   $0xef000008,0x8014fec2
80106a3e:	00 00 ef 
  initlock(&tickslock, "time");
80106a41:	68 6b 8a 10 80       	push   $0x80108a6b
80106a46:	68 80 fc 14 80       	push   $0x8014fc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a4b:	66 a3 c0 fe 14 80    	mov    %ax,0x8014fec0
80106a51:	c1 e8 10             	shr    $0x10,%eax
80106a54:	66 a3 c6 fe 14 80    	mov    %ax,0x8014fec6
  initlock(&tickslock, "time");
80106a5a:	e8 a1 dc ff ff       	call   80104700 <initlock>
}
80106a5f:	83 c4 10             	add    $0x10,%esp
80106a62:	c9                   	leave
80106a63:	c3                   	ret
80106a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a6f:	90                   	nop

80106a70 <idtinit>:

void
idtinit(void)
{
80106a70:	55                   	push   %ebp
  pd[0] = size-1;
80106a71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a76:	89 e5                	mov    %esp,%ebp
80106a78:	83 ec 10             	sub    $0x10,%esp
80106a7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a7f:	b8 c0 fc 14 80       	mov    $0x8014fcc0,%eax
80106a84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a88:	c1 e8 10             	shr    $0x10,%eax
80106a8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106a95:	c9                   	leave
80106a96:	c3                   	ret
80106a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9e:	66 90                	xchg   %ax,%ax

80106aa0 <addPhysicalPage>:

void addPhysicalPage(uint mappedAddress, char* mem){
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *currproc = myproc();
80106aac:	e8 af ce ff ff       	call   80103960 <myproc>
			//uint tempHolder = (mappedAddress - (currproc->allAddresses)[i].startingVirtualAddr)/PGSIZE;
			//cprintf("%x %x\n",(currproc->allAddresses)[i].startingVirtualAddr, tempHolder );
			((currproc->allAddresses)[i].physicalPageNumber)++;
			for(int j=0; j<16; j++){
				if(((currproc->allAddresses)[i].forFork[j]) == 0){
					((currproc->allAddresses)[i].forFork[j]) = V2P(mem);
80106ab1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for(int i=0; i<16; i++){
80106ab4:	31 c9                	xor    %ecx,%ecx
	struct proc *currproc = myproc();
80106ab6:	89 c6                	mov    %eax,%esi
					((currproc->allAddresses)[i].forFork[j]) = V2P(mem);
80106ab8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106abe:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106ac1:	eb 12                	jmp    80106ad5 <addPhysicalPage+0x35>
80106ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ac7:	90                   	nop
	for(int i=0; i<16; i++){
80106ac8:	83 c1 01             	add    $0x1,%ecx
80106acb:	05 e8 00 00 00       	add    $0xe8,%eax
80106ad0:	83 f9 10             	cmp    $0x10,%ecx
80106ad3:	74 49                	je     80106b1e <addPhysicalPage+0x7e>
		if((currproc->allAddresses)[i].startingVirtualAddr <= mappedAddress && (currproc->allAddresses)[i].endingVirtualAddr > mappedAddress){
80106ad5:	3b 58 7c             	cmp    0x7c(%eax),%ebx
80106ad8:	72 ee                	jb     80106ac8 <addPhysicalPage+0x28>
80106ada:	3b 98 80 00 00 00    	cmp    0x80(%eax),%ebx
80106ae0:	73 e6                	jae    80106ac8 <addPhysicalPage+0x28>
			((currproc->allAddresses)[i].physicalPageNumber)++;
80106ae2:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
			for(int j=0; j<16; j++){
80106ae9:	31 d2                	xor    %edx,%edx
80106aeb:	eb 0b                	jmp    80106af8 <addPhysicalPage+0x58>
80106aed:	8d 76 00             	lea    0x0(%esi),%esi
80106af0:	83 c2 01             	add    $0x1,%edx
80106af3:	83 fa 10             	cmp    $0x10,%edx
80106af6:	74 d0                	je     80106ac8 <addPhysicalPage+0x28>
				if(((currproc->allAddresses)[i].forFork[j]) == 0){
80106af8:	8b bc 90 0c 01 00 00 	mov    0x10c(%eax,%edx,4),%edi
80106aff:	85 ff                	test   %edi,%edi
80106b01:	75 ed                	jne    80106af0 <addPhysicalPage+0x50>
					((currproc->allAddresses)[i].forFork[j]) = V2P(mem);
80106b03:	6b f9 3a             	imul   $0x3a,%ecx,%edi
	for(int i=0; i<16; i++){
80106b06:	83 c1 01             	add    $0x1,%ecx
80106b09:	05 e8 00 00 00       	add    $0xe8,%eax
					((currproc->allAddresses)[i].forFork[j]) = V2P(mem);
80106b0e:	8d 54 3a 40          	lea    0x40(%edx,%edi,1),%edx
80106b12:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106b15:	89 7c 96 0c          	mov    %edi,0xc(%esi,%edx,4)
	for(int i=0; i<16; i++){
80106b19:	83 f9 10             	cmp    $0x10,%ecx
80106b1c:	75 b7                	jne    80106ad5 <addPhysicalPage+0x35>
				}
			}
			//((currproc->allAddresses)[i].forFork[tempHolder]) = V2P(mem);
		}
	}
}
80106b1e:	83 c4 1c             	add    $0x1c,%esp
80106b21:	5b                   	pop    %ebx
80106b22:	5e                   	pop    %esi
80106b23:	5f                   	pop    %edi
80106b24:	5d                   	pop    %ebp
80106b25:	c3                   	ret
80106b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi

80106b30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 2c             	sub    $0x2c,%esp
80106b39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(tf->trapno == T_SYSCALL){
80106b3c:	8b 46 30             	mov    0x30(%esi),%eax
80106b3f:	83 f8 40             	cmp    $0x40,%eax
80106b42:	0f 84 30 01 00 00    	je     80106c78 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106b48:	83 e8 0e             	sub    $0xe,%eax
80106b4b:	83 f8 31             	cmp    $0x31,%eax
80106b4e:	0f 87 84 00 00 00    	ja     80106bd8 <trap+0xa8>
80106b54:	ff 24 85 6c 90 10 80 	jmp    *-0x7fef6f94(,%eax,4)
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106b5b:	e8 e0 cd ff ff       	call   80103940 <cpuid>
80106b60:	85 c0                	test   %eax,%eax
80106b62:	0f 84 c8 03 00 00    	je     80106f30 <trap+0x400>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106b68:	e8 83 bd ff ff       	call   801028f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b6d:	e8 ee cd ff ff       	call   80103960 <myproc>
80106b72:	85 c0                	test   %eax,%eax
80106b74:	74 1a                	je     80106b90 <trap+0x60>
80106b76:	e8 e5 cd ff ff       	call   80103960 <myproc>
80106b7b:	8b 50 24             	mov    0x24(%eax),%edx
80106b7e:	85 d2                	test   %edx,%edx
80106b80:	74 0e                	je     80106b90 <trap+0x60>
80106b82:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
80106b86:	f7 d0                	not    %eax
80106b88:	a8 03                	test   $0x3,%al
80106b8a:	0f 84 60 03 00 00    	je     80106ef0 <trap+0x3c0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106b90:	e8 cb cd ff ff       	call   80103960 <myproc>
80106b95:	85 c0                	test   %eax,%eax
80106b97:	74 0f                	je     80106ba8 <trap+0x78>
80106b99:	e8 c2 cd ff ff       	call   80103960 <myproc>
80106b9e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106ba2:	0f 84 b8 00 00 00    	je     80106c60 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ba8:	e8 b3 cd ff ff       	call   80103960 <myproc>
80106bad:	85 c0                	test   %eax,%eax
80106baf:	74 1a                	je     80106bcb <trap+0x9b>
80106bb1:	e8 aa cd ff ff       	call   80103960 <myproc>
80106bb6:	8b 40 24             	mov    0x24(%eax),%eax
80106bb9:	85 c0                	test   %eax,%eax
80106bbb:	74 0e                	je     80106bcb <trap+0x9b>
80106bbd:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
80106bc1:	f7 d0                	not    %eax
80106bc3:	a8 03                	test   $0x3,%al
80106bc5:	0f 84 da 00 00 00    	je     80106ca5 <trap+0x175>
    exit();
}
80106bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bce:	5b                   	pop    %ebx
80106bcf:	5e                   	pop    %esi
80106bd0:	5f                   	pop    %edi
80106bd1:	5d                   	pop    %ebp
80106bd2:	c3                   	ret
80106bd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bd7:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80106bd8:	e8 83 cd ff ff       	call   80103960 <myproc>
80106bdd:	8b 7e 38             	mov    0x38(%esi),%edi
80106be0:	85 c0                	test   %eax,%eax
80106be2:	0f 84 b7 03 00 00    	je     80106f9f <trap+0x46f>
80106be8:	f6 46 3c 03          	testb  $0x3,0x3c(%esi)
80106bec:	0f 84 ad 03 00 00    	je     80106f9f <trap+0x46f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106bf2:	0f 20 d1             	mov    %cr2,%ecx
80106bf5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bf8:	e8 43 cd ff ff       	call   80103940 <cpuid>
80106bfd:	8b 5e 30             	mov    0x30(%esi),%ebx
80106c00:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c03:	8b 46 34             	mov    0x34(%esi),%eax
80106c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106c09:	e8 52 cd ff ff       	call   80103960 <myproc>
80106c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c11:	e8 4a cd ff ff       	call   80103960 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c16:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106c19:	51                   	push   %ecx
80106c1a:	57                   	push   %edi
80106c1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106c1e:	52                   	push   %edx
80106c1f:	ff 75 e4             	push   -0x1c(%ebp)
80106c22:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
80106c23:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80106c26:	83 c3 6c             	add    $0x6c,%ebx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c29:	53                   	push   %ebx
80106c2a:	ff 70 10             	push   0x10(%eax)
80106c2d:	68 50 8d 10 80       	push   $0x80108d50
80106c32:	e8 79 9a ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80106c37:	83 c4 20             	add    $0x20,%esp
80106c3a:	e8 21 cd ff ff       	call   80103960 <myproc>
80106c3f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c46:	e8 15 cd ff ff       	call   80103960 <myproc>
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	0f 85 23 ff ff ff    	jne    80106b76 <trap+0x46>
80106c53:	e9 38 ff ff ff       	jmp    80106b90 <trap+0x60>
80106c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c5f:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80106c60:	83 7e 30 20          	cmpl   $0x20,0x30(%esi)
80106c64:	0f 85 3e ff ff ff    	jne    80106ba8 <trap+0x78>
    yield();
80106c6a:	e8 b1 d6 ff ff       	call   80104320 <yield>
80106c6f:	e9 34 ff ff ff       	jmp    80106ba8 <trap+0x78>
80106c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106c78:	e8 e3 cc ff ff       	call   80103960 <myproc>
80106c7d:	8b 78 24             	mov    0x24(%eax),%edi
80106c80:	85 ff                	test   %edi,%edi
80106c82:	0f 85 98 02 00 00    	jne    80106f20 <trap+0x3f0>
    myproc()->tf = tf;
80106c88:	e8 d3 cc ff ff       	call   80103960 <myproc>
80106c8d:	89 70 18             	mov    %esi,0x18(%eax)
    syscall();
80106c90:	e8 4b e1 ff ff       	call   80104de0 <syscall>
    if(myproc()->killed)
80106c95:	e8 c6 cc ff ff       	call   80103960 <myproc>
80106c9a:	8b 58 24             	mov    0x24(%eax),%ebx
80106c9d:	85 db                	test   %ebx,%ebx
80106c9f:	0f 84 26 ff ff ff    	je     80106bcb <trap+0x9b>
}
80106ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca8:	5b                   	pop    %ebx
80106ca9:	5e                   	pop    %esi
80106caa:	5f                   	pop    %edi
80106cab:	5d                   	pop    %ebp
      exit();
80106cac:	e9 bf d3 ff ff       	jmp    80104070 <exit>
80106cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cb8:	8b 7e 38             	mov    0x38(%esi),%edi
80106cbb:	0f b7 5e 3c          	movzwl 0x3c(%esi),%ebx
80106cbf:	e8 7c cc ff ff       	call   80103940 <cpuid>
80106cc4:	57                   	push   %edi
80106cc5:	53                   	push   %ebx
80106cc6:	50                   	push   %eax
80106cc7:	68 f8 8c 10 80       	push   $0x80108cf8
80106ccc:	e8 df 99 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106cd1:	e8 1a bc ff ff       	call   801028f0 <lapiceoi>
    break;
80106cd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106cd9:	e8 82 cc ff ff       	call   80103960 <myproc>
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	0f 85 90 fe ff ff    	jne    80106b76 <trap+0x46>
80106ce6:	e9 a5 fe ff ff       	jmp    80106b90 <trap+0x60>
    kbdintr();
80106ceb:	e8 d0 ba ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80106cf0:	e8 fb bb ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106cf5:	e8 66 cc ff ff       	call   80103960 <myproc>
80106cfa:	85 c0                	test   %eax,%eax
80106cfc:	0f 85 74 fe ff ff    	jne    80106b76 <trap+0x46>
80106d02:	e9 89 fe ff ff       	jmp    80106b90 <trap+0x60>
    uartintr();
80106d07:	e8 44 04 00 00       	call   80107150 <uartintr>
    lapiceoi();
80106d0c:	e8 df bb ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d11:	e8 4a cc ff ff       	call   80103960 <myproc>
80106d16:	85 c0                	test   %eax,%eax
80106d18:	0f 85 58 fe ff ff    	jne    80106b76 <trap+0x46>
80106d1e:	e9 6d fe ff ff       	jmp    80106b90 <trap+0x60>
    ideintr();
80106d23:	e8 08 b5 ff ff       	call   80102230 <ideintr>
80106d28:	e9 3b fe ff ff       	jmp    80106b68 <trap+0x38>
80106d2d:	0f 20 d3             	mov    %cr2,%ebx
			for(int i=0; i<16; i++){
80106d30:	31 ff                	xor    %edi,%edi
					placement = i;
80106d32:	89 75 e4             	mov    %esi,-0x1c(%ebp)
		uint tempAddress = PGROUNDDOWN(rcr2()); // Fetches the address that needs to have memory physically allocated
80106d35:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		int placement = 0;
80106d3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
					placement = i;
80106d42:	89 fe                	mov    %edi,%esi
		int inAddressSpace = 0;
80106d44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80106d4b:	eb 0b                	jmp    80106d58 <trap+0x228>
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi
			for(int i=0; i<16; i++){
80106d50:	83 c6 01             	add    $0x1,%esi
80106d53:	83 fe 10             	cmp    $0x10,%esi
80106d56:	74 3a                	je     80106d92 <trap+0x262>
				if((myproc()->allAddresses)[i].startingVirtualAddr <= tempAddress && (myproc()->allAddresses)[i].endingVirtualAddr >= tempAddress){
80106d58:	e8 03 cc ff ff       	call   80103960 <myproc>
80106d5d:	69 fe e8 00 00 00    	imul   $0xe8,%esi,%edi
80106d63:	3b 5c 07 7c          	cmp    0x7c(%edi,%eax,1),%ebx
80106d67:	72 e7                	jb     80106d50 <trap+0x220>
80106d69:	e8 f2 cb ff ff       	call   80103960 <myproc>
					placement = i;
80106d6e:	39 9c 07 80 00 00 00 	cmp    %ebx,0x80(%edi,%eax,1)
80106d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d78:	0f 43 c6             	cmovae %esi,%eax
80106d7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d7e:	b8 01 00 00 00       	mov    $0x1,%eax
80106d83:	0f 42 45 dc          	cmovb  -0x24(%ebp),%eax
			for(int i=0; i<16; i++){
80106d87:	83 c6 01             	add    $0x1,%esi
					placement = i;
80106d8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			for(int i=0; i<16; i++){
80106d8d:	83 fe 10             	cmp    $0x10,%esi
80106d90:	75 c6                	jne    80106d58 <trap+0x228>
				uint findAddress = myproc()->allAddresses[placement].startingVirtualAddr + i*PGSIZE;
80106d92:	69 45 e0 e8 00 00 00 	imul   $0xe8,-0x20(%ebp),%eax
			for(int i=0; i<16; i++){
80106d99:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106d9c:	31 ff                	xor    %edi,%edi
		int page = 0;
80106d9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
				uint findAddress = myproc()->allAddresses[placement].startingVirtualAddr + i*PGSIZE;
80106da5:	89 75 d8             	mov    %esi,-0x28(%ebp)
80106da8:	89 c6                	mov    %eax,%esi
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106db0:	e8 ab cb ff ff       	call   80103960 <myproc>
80106db5:	89 c1                	mov    %eax,%ecx
80106db7:	89 f8                	mov    %edi,%eax
80106db9:	c1 e0 0c             	shl    $0xc,%eax
80106dbc:	03 44 0e 7c          	add    0x7c(%esi,%ecx,1),%eax
				if(findAddress <= tempAddress && findAddress+PGSIZE > tempAddress){
80106dc0:	39 c3                	cmp    %eax,%ebx
80106dc2:	72 10                	jb     80106dd4 <trap+0x2a4>
80106dc4:	05 00 10 00 00       	add    $0x1000,%eax
					page = i;
80106dc9:	39 c3                	cmp    %eax,%ebx
80106dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dce:	0f 42 c7             	cmovb  %edi,%eax
80106dd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for(int i=0; i<16; i++){
80106dd4:	83 c7 01             	add    $0x1,%edi
80106dd7:	83 ff 10             	cmp    $0x10,%edi
80106dda:	75 d4                	jne    80106db0 <trap+0x280>
			if(inAddressSpace != 0){
80106ddc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80106ddf:	8b 75 d8             	mov    -0x28(%ebp),%esi
80106de2:	85 c9                	test   %ecx,%ecx
80106de4:	0f 84 de 00 00 00    	je     80106ec8 <trap+0x398>
				char* mem = kalloc();
80106dea:	e8 71 b8 ff ff       	call   80102660 <kalloc>
80106def:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(mem == 0){
80106df2:	85 c0                	test   %eax,%eax
80106df4:	0f 84 00 01 00 00    	je     80106efa <trap+0x3ca>
					if(myproc()->allAddresses[placement].isAnonymous == 1){
80106dfa:	e8 61 cb ff ff       	call   80103960 <myproc>
80106dff:	69 4d e0 e8 00 00 00 	imul   $0xe8,-0x20(%ebp),%ecx
						for (int i = 0; i < NOFILE; i++) {
80106e06:	31 ff                	xor    %edi,%edi
						int fd = -1;
80106e08:	ba ff ff ff ff       	mov    $0xffffffff,%edx
					if(myproc()->allAddresses[placement].isAnonymous == 1){
80106e0d:	83 bc 01 54 01 00 00 	cmpl   $0x1,0x154(%ecx,%eax,1)
80106e14:	01 
80106e15:	0f 84 6a 01 00 00    	je     80106f85 <trap+0x455>
80106e1b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80106e1e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106e21:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80106e24:	89 d6                	mov    %edx,%esi
80106e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi
							f = myproc()->ofile[i];
80106e30:	e8 2b cb ff ff       	call   80103960 <myproc>
80106e35:	8b 5c b8 28          	mov    0x28(%eax,%edi,4),%ebx
							if (f == myproc()->allAddresses[placement].fd)
80106e39:	e8 22 cb ff ff       	call   80103960 <myproc>
								fd = i;
80106e3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106e41:	39 9c 02 58 01 00 00 	cmp    %ebx,0x158(%edx,%eax,1)
80106e48:	0f 44 f7             	cmove  %edi,%esi
						for (int i = 0; i < NOFILE; i++) {
80106e4b:	83 c7 01             	add    $0x1,%edi
80106e4e:	83 ff 10             	cmp    $0x10,%edi
80106e51:	75 dd                	jne    80106e30 <trap+0x300>
						struct inode* ip = (myproc()->ofile)[fd]->ip;
80106e53:	89 75 e0             	mov    %esi,-0x20(%ebp)
80106e56:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80106e59:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80106e5c:	e8 ff ca ff ff       	call   80103960 <myproc>
						readi(ip, (char*)mem, (uint)page*PGSIZE, (uint)PGSIZE);
80106e61:	68 00 10 00 00       	push   $0x1000
						struct inode* ip = (myproc()->ofile)[fd]->ip;
80106e66:	89 c1                	mov    %eax,%ecx
						readi(ip, (char*)mem, (uint)page*PGSIZE, (uint)PGSIZE);
80106e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e6b:	c1 e0 0c             	shl    $0xc,%eax
80106e6e:	50                   	push   %eax
80106e6f:	ff 75 dc             	push   -0x24(%ebp)
						struct inode* ip = (myproc()->ofile)[fd]->ip;
80106e72:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106e75:	8b 44 91 28          	mov    0x28(%ecx,%edx,4),%eax
						readi(ip, (char*)mem, (uint)page*PGSIZE, (uint)PGSIZE);
80106e79:	ff 70 10             	push   0x10(%eax)
80106e7c:	e8 2f ac ff ff       	call   80101ab0 <readi>
80106e81:	83 c4 10             	add    $0x10,%esp
					if(mappages(myproc()->pgdir, (char*)tempAddress, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0){ // The actual mapping of the pages
80106e84:	e8 d7 ca ff ff       	call   80103960 <myproc>
80106e89:	83 ec 0c             	sub    $0xc,%esp
80106e8c:	6a 06                	push   $0x6
80106e8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106e91:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e97:	52                   	push   %edx
80106e98:	68 00 10 00 00       	push   $0x1000
80106e9d:	53                   	push   %ebx
80106e9e:	ff 70 04             	push   0x4(%eax)
80106ea1:	e8 1a 0f 00 00       	call   80107dc0 <mappages>
80106ea6:	83 c4 20             	add    $0x20,%esp
80106ea9:	85 c0                	test   %eax,%eax
80106eab:	0f 88 b3 00 00 00    	js     80106f64 <trap+0x434>
				addPhysicalPage(tempAddress, mem);
80106eb1:	83 ec 08             	sub    $0x8,%esp
80106eb4:	ff 75 dc             	push   -0x24(%ebp)
80106eb7:	53                   	push   %ebx
80106eb8:	e8 e3 fb ff ff       	call   80106aa0 <addPhysicalPage>
80106ebd:	83 c4 10             	add    $0x10,%esp
80106ec0:	e9 a8 fc ff ff       	jmp    80106b6d <trap+0x3d>
80106ec5:	8d 76 00             	lea    0x0(%esi),%esi
				cprintf("Segmentation Fault\n");
80106ec8:	83 ec 0c             	sub    $0xc,%esp
80106ecb:	68 84 8a 10 80       	push   $0x80108a84
80106ed0:	e8 db 97 ff ff       	call   801006b0 <cprintf>
				myproc()->killed = 1;
80106ed5:	e8 86 ca ff ff       	call   80103960 <myproc>
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106ee4:	e9 84 fc ff ff       	jmp    80106b6d <trap+0x3d>
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106ef0:	e8 7b d1 ff ff       	call   80104070 <exit>
80106ef5:	e9 96 fc ff ff       	jmp    80106b90 <trap+0x60>
					cprintf("Not able to kalloc\n");
80106efa:	83 ec 0c             	sub    $0xc,%esp
80106efd:	68 70 8a 10 80       	push   $0x80108a70
80106f02:	e8 a9 97 ff ff       	call   801006b0 <cprintf>
					myproc()->killed = 1;
80106f07:	e8 54 ca ff ff       	call   80103960 <myproc>
80106f0c:	83 c4 10             	add    $0x10,%esp
80106f0f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106f16:	eb 99                	jmp    80106eb1 <trap+0x381>
80106f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop
      exit();
80106f20:	e8 4b d1 ff ff       	call   80104070 <exit>
80106f25:	e9 5e fd ff ff       	jmp    80106c88 <trap+0x158>
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106f30:	83 ec 0c             	sub    $0xc,%esp
80106f33:	68 80 fc 14 80       	push   $0x8014fc80
80106f38:	e8 b3 d9 ff ff       	call   801048f0 <acquire>
      ticks++;
80106f3d:	83 05 60 fc 14 80 01 	addl   $0x1,0x8014fc60
      wakeup(&ticks);
80106f44:	c7 04 24 60 fc 14 80 	movl   $0x8014fc60,(%esp)
80106f4b:	e8 e0 d4 ff ff       	call   80104430 <wakeup>
      release(&tickslock);
80106f50:	c7 04 24 80 fc 14 80 	movl   $0x8014fc80,(%esp)
80106f57:	e8 34 d9 ff ff       	call   80104890 <release>
80106f5c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106f5f:	e9 04 fc ff ff       	jmp    80106b68 <trap+0x38>
						cprintf("mappages() not working\n");
80106f64:	83 ec 0c             	sub    $0xc,%esp
80106f67:	68 42 8a 10 80       	push   $0x80108a42
80106f6c:	e8 3f 97 ff ff       	call   801006b0 <cprintf>
						myproc()->killed = 1;
80106f71:	e8 ea c9 ff ff       	call   80103960 <myproc>
80106f76:	83 c4 10             	add    $0x10,%esp
80106f79:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106f80:	e9 2c ff ff ff       	jmp    80106eb1 <trap+0x381>
						memset(mem, 0, PGSIZE);
80106f85:	83 ec 04             	sub    $0x4,%esp
80106f88:	68 00 10 00 00       	push   $0x1000
80106f8d:	6a 00                	push   $0x0
80106f8f:	ff 75 dc             	push   -0x24(%ebp)
80106f92:	e8 59 da ff ff       	call   801049f0 <memset>
80106f97:	83 c4 10             	add    $0x10,%esp
80106f9a:	e9 e5 fe ff ff       	jmp    80106e84 <trap+0x354>
80106f9f:	0f 20 d3             	mov    %cr2,%ebx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106fa2:	e8 99 c9 ff ff       	call   80103940 <cpuid>
80106fa7:	83 ec 0c             	sub    $0xc,%esp
80106faa:	53                   	push   %ebx
80106fab:	57                   	push   %edi
80106fac:	50                   	push   %eax
80106fad:	ff 76 30             	push   0x30(%esi)
80106fb0:	68 1c 8d 10 80       	push   $0x80108d1c
80106fb5:	e8 f6 96 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106fba:	83 c4 14             	add    $0x14,%esp
80106fbd:	68 98 8a 10 80       	push   $0x80108a98
80106fc2:	e8 b9 93 ff ff       	call   80100380 <panic>
80106fc7:	66 90                	xchg   %ax,%ax
80106fc9:	66 90                	xchg   %ax,%ax
80106fcb:	66 90                	xchg   %ax,%ax
80106fcd:	66 90                	xchg   %ax,%ax
80106fcf:	90                   	nop

80106fd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106fd0:	a1 c0 04 15 80       	mov    0x801504c0,%eax
80106fd5:	85 c0                	test   %eax,%eax
80106fd7:	74 17                	je     80106ff0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106fd9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106fde:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106fdf:	a8 01                	test   $0x1,%al
80106fe1:	74 0d                	je     80106ff0 <uartgetc+0x20>
80106fe3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fe8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106fe9:	0f b6 c0             	movzbl %al,%eax
80106fec:	c3                   	ret
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ff5:	c3                   	ret
80106ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ffd:	8d 76 00             	lea    0x0(%esi),%esi

80107000 <uartinit>:
{
80107000:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107001:	31 c9                	xor    %ecx,%ecx
80107003:	89 c8                	mov    %ecx,%eax
80107005:	89 e5                	mov    %esp,%ebp
80107007:	57                   	push   %edi
80107008:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010700d:	56                   	push   %esi
8010700e:	89 fa                	mov    %edi,%edx
80107010:	53                   	push   %ebx
80107011:	83 ec 1c             	sub    $0x1c,%esp
80107014:	ee                   	out    %al,(%dx)
80107015:	be fb 03 00 00       	mov    $0x3fb,%esi
8010701a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010701f:	89 f2                	mov    %esi,%edx
80107021:	ee                   	out    %al,(%dx)
80107022:	b8 0c 00 00 00       	mov    $0xc,%eax
80107027:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010702c:	ee                   	out    %al,(%dx)
8010702d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107032:	89 c8                	mov    %ecx,%eax
80107034:	89 da                	mov    %ebx,%edx
80107036:	ee                   	out    %al,(%dx)
80107037:	b8 03 00 00 00       	mov    $0x3,%eax
8010703c:	89 f2                	mov    %esi,%edx
8010703e:	ee                   	out    %al,(%dx)
8010703f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107044:	89 c8                	mov    %ecx,%eax
80107046:	ee                   	out    %al,(%dx)
80107047:	b8 01 00 00 00       	mov    $0x1,%eax
8010704c:	89 da                	mov    %ebx,%edx
8010704e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010704f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107054:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107055:	3c ff                	cmp    $0xff,%al
80107057:	0f 84 7c 00 00 00    	je     801070d9 <uartinit+0xd9>
  uart = 1;
8010705d:	c7 05 c0 04 15 80 01 	movl   $0x1,0x801504c0
80107064:	00 00 00 
80107067:	89 fa                	mov    %edi,%edx
80107069:	ec                   	in     (%dx),%al
8010706a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010706f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107070:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80107073:	bf 9d 8a 10 80       	mov    $0x80108a9d,%edi
80107078:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010707d:	6a 00                	push   $0x0
8010707f:	6a 04                	push   $0x4
80107081:	e8 da b3 ff ff       	call   80102460 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107086:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010708a:	83 c4 10             	add    $0x10,%esp
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80107090:	a1 c0 04 15 80       	mov    0x801504c0,%eax
80107095:	85 c0                	test   %eax,%eax
80107097:	74 32                	je     801070cb <uartinit+0xcb>
80107099:	89 f2                	mov    %esi,%edx
8010709b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010709c:	a8 20                	test   $0x20,%al
8010709e:	75 21                	jne    801070c1 <uartinit+0xc1>
801070a0:	bb 80 00 00 00       	mov    $0x80,%ebx
801070a5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801070a8:	83 ec 0c             	sub    $0xc,%esp
801070ab:	6a 0a                	push   $0xa
801070ad:	e8 5e b8 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070b2:	83 c4 10             	add    $0x10,%esp
801070b5:	83 eb 01             	sub    $0x1,%ebx
801070b8:	74 07                	je     801070c1 <uartinit+0xc1>
801070ba:	89 f2                	mov    %esi,%edx
801070bc:	ec                   	in     (%dx),%al
801070bd:	a8 20                	test   $0x20,%al
801070bf:	74 e7                	je     801070a8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801070c1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070c6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801070ca:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801070cb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801070cf:	83 c7 01             	add    $0x1,%edi
801070d2:	88 45 e7             	mov    %al,-0x19(%ebp)
801070d5:	84 c0                	test   %al,%al
801070d7:	75 b7                	jne    80107090 <uartinit+0x90>
}
801070d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070dc:	5b                   	pop    %ebx
801070dd:	5e                   	pop    %esi
801070de:	5f                   	pop    %edi
801070df:	5d                   	pop    %ebp
801070e0:	c3                   	ret
801070e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop

801070f0 <uartputc>:
  if(!uart)
801070f0:	a1 c0 04 15 80       	mov    0x801504c0,%eax
801070f5:	85 c0                	test   %eax,%eax
801070f7:	74 4f                	je     80107148 <uartputc+0x58>
{
801070f9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801070fa:	ba fd 03 00 00       	mov    $0x3fd,%edx
801070ff:	89 e5                	mov    %esp,%ebp
80107101:	56                   	push   %esi
80107102:	53                   	push   %ebx
80107103:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107104:	a8 20                	test   $0x20,%al
80107106:	75 29                	jne    80107131 <uartputc+0x41>
80107108:	bb 80 00 00 00       	mov    $0x80,%ebx
8010710d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	6a 0a                	push   $0xa
8010711d:	e8 ee b7 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107122:	83 c4 10             	add    $0x10,%esp
80107125:	83 eb 01             	sub    $0x1,%ebx
80107128:	74 07                	je     80107131 <uartputc+0x41>
8010712a:	89 f2                	mov    %esi,%edx
8010712c:	ec                   	in     (%dx),%al
8010712d:	a8 20                	test   $0x20,%al
8010712f:	74 e7                	je     80107118 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107131:	8b 45 08             	mov    0x8(%ebp),%eax
80107134:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107139:	ee                   	out    %al,(%dx)
}
8010713a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010713d:	5b                   	pop    %ebx
8010713e:	5e                   	pop    %esi
8010713f:	5d                   	pop    %ebp
80107140:	c3                   	ret
80107141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107148:	c3                   	ret
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107150 <uartintr>:

void
uartintr(void)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107156:	68 d0 6f 10 80       	push   $0x80106fd0
8010715b:	e8 40 97 ff ff       	call   801008a0 <consoleintr>
}
80107160:	83 c4 10             	add    $0x10,%esp
80107163:	c9                   	leave
80107164:	c3                   	ret

80107165 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $0
80107167:	6a 00                	push   $0x0
  jmp alltraps
80107169:	e9 55 f8 ff ff       	jmp    801069c3 <alltraps>

8010716e <vector1>:
.globl vector1
vector1:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $1
80107170:	6a 01                	push   $0x1
  jmp alltraps
80107172:	e9 4c f8 ff ff       	jmp    801069c3 <alltraps>

80107177 <vector2>:
.globl vector2
vector2:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $2
80107179:	6a 02                	push   $0x2
  jmp alltraps
8010717b:	e9 43 f8 ff ff       	jmp    801069c3 <alltraps>

80107180 <vector3>:
.globl vector3
vector3:
  pushl $0
80107180:	6a 00                	push   $0x0
  pushl $3
80107182:	6a 03                	push   $0x3
  jmp alltraps
80107184:	e9 3a f8 ff ff       	jmp    801069c3 <alltraps>

80107189 <vector4>:
.globl vector4
vector4:
  pushl $0
80107189:	6a 00                	push   $0x0
  pushl $4
8010718b:	6a 04                	push   $0x4
  jmp alltraps
8010718d:	e9 31 f8 ff ff       	jmp    801069c3 <alltraps>

80107192 <vector5>:
.globl vector5
vector5:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $5
80107194:	6a 05                	push   $0x5
  jmp alltraps
80107196:	e9 28 f8 ff ff       	jmp    801069c3 <alltraps>

8010719b <vector6>:
.globl vector6
vector6:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $6
8010719d:	6a 06                	push   $0x6
  jmp alltraps
8010719f:	e9 1f f8 ff ff       	jmp    801069c3 <alltraps>

801071a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801071a4:	6a 00                	push   $0x0
  pushl $7
801071a6:	6a 07                	push   $0x7
  jmp alltraps
801071a8:	e9 16 f8 ff ff       	jmp    801069c3 <alltraps>

801071ad <vector8>:
.globl vector8
vector8:
  pushl $8
801071ad:	6a 08                	push   $0x8
  jmp alltraps
801071af:	e9 0f f8 ff ff       	jmp    801069c3 <alltraps>

801071b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $9
801071b6:	6a 09                	push   $0x9
  jmp alltraps
801071b8:	e9 06 f8 ff ff       	jmp    801069c3 <alltraps>

801071bd <vector10>:
.globl vector10
vector10:
  pushl $10
801071bd:	6a 0a                	push   $0xa
  jmp alltraps
801071bf:	e9 ff f7 ff ff       	jmp    801069c3 <alltraps>

801071c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801071c4:	6a 0b                	push   $0xb
  jmp alltraps
801071c6:	e9 f8 f7 ff ff       	jmp    801069c3 <alltraps>

801071cb <vector12>:
.globl vector12
vector12:
  pushl $12
801071cb:	6a 0c                	push   $0xc
  jmp alltraps
801071cd:	e9 f1 f7 ff ff       	jmp    801069c3 <alltraps>

801071d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801071d2:	6a 0d                	push   $0xd
  jmp alltraps
801071d4:	e9 ea f7 ff ff       	jmp    801069c3 <alltraps>

801071d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801071d9:	6a 0e                	push   $0xe
  jmp alltraps
801071db:	e9 e3 f7 ff ff       	jmp    801069c3 <alltraps>

801071e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801071e0:	6a 00                	push   $0x0
  pushl $15
801071e2:	6a 0f                	push   $0xf
  jmp alltraps
801071e4:	e9 da f7 ff ff       	jmp    801069c3 <alltraps>

801071e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801071e9:	6a 00                	push   $0x0
  pushl $16
801071eb:	6a 10                	push   $0x10
  jmp alltraps
801071ed:	e9 d1 f7 ff ff       	jmp    801069c3 <alltraps>

801071f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801071f2:	6a 11                	push   $0x11
  jmp alltraps
801071f4:	e9 ca f7 ff ff       	jmp    801069c3 <alltraps>

801071f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $18
801071fb:	6a 12                	push   $0x12
  jmp alltraps
801071fd:	e9 c1 f7 ff ff       	jmp    801069c3 <alltraps>

80107202 <vector19>:
.globl vector19
vector19:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $19
80107204:	6a 13                	push   $0x13
  jmp alltraps
80107206:	e9 b8 f7 ff ff       	jmp    801069c3 <alltraps>

8010720b <vector20>:
.globl vector20
vector20:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $20
8010720d:	6a 14                	push   $0x14
  jmp alltraps
8010720f:	e9 af f7 ff ff       	jmp    801069c3 <alltraps>

80107214 <vector21>:
.globl vector21
vector21:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $21
80107216:	6a 15                	push   $0x15
  jmp alltraps
80107218:	e9 a6 f7 ff ff       	jmp    801069c3 <alltraps>

8010721d <vector22>:
.globl vector22
vector22:
  pushl $0
8010721d:	6a 00                	push   $0x0
  pushl $22
8010721f:	6a 16                	push   $0x16
  jmp alltraps
80107221:	e9 9d f7 ff ff       	jmp    801069c3 <alltraps>

80107226 <vector23>:
.globl vector23
vector23:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $23
80107228:	6a 17                	push   $0x17
  jmp alltraps
8010722a:	e9 94 f7 ff ff       	jmp    801069c3 <alltraps>

8010722f <vector24>:
.globl vector24
vector24:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $24
80107231:	6a 18                	push   $0x18
  jmp alltraps
80107233:	e9 8b f7 ff ff       	jmp    801069c3 <alltraps>

80107238 <vector25>:
.globl vector25
vector25:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $25
8010723a:	6a 19                	push   $0x19
  jmp alltraps
8010723c:	e9 82 f7 ff ff       	jmp    801069c3 <alltraps>

80107241 <vector26>:
.globl vector26
vector26:
  pushl $0
80107241:	6a 00                	push   $0x0
  pushl $26
80107243:	6a 1a                	push   $0x1a
  jmp alltraps
80107245:	e9 79 f7 ff ff       	jmp    801069c3 <alltraps>

8010724a <vector27>:
.globl vector27
vector27:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $27
8010724c:	6a 1b                	push   $0x1b
  jmp alltraps
8010724e:	e9 70 f7 ff ff       	jmp    801069c3 <alltraps>

80107253 <vector28>:
.globl vector28
vector28:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $28
80107255:	6a 1c                	push   $0x1c
  jmp alltraps
80107257:	e9 67 f7 ff ff       	jmp    801069c3 <alltraps>

8010725c <vector29>:
.globl vector29
vector29:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $29
8010725e:	6a 1d                	push   $0x1d
  jmp alltraps
80107260:	e9 5e f7 ff ff       	jmp    801069c3 <alltraps>

80107265 <vector30>:
.globl vector30
vector30:
  pushl $0
80107265:	6a 00                	push   $0x0
  pushl $30
80107267:	6a 1e                	push   $0x1e
  jmp alltraps
80107269:	e9 55 f7 ff ff       	jmp    801069c3 <alltraps>

8010726e <vector31>:
.globl vector31
vector31:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $31
80107270:	6a 1f                	push   $0x1f
  jmp alltraps
80107272:	e9 4c f7 ff ff       	jmp    801069c3 <alltraps>

80107277 <vector32>:
.globl vector32
vector32:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $32
80107279:	6a 20                	push   $0x20
  jmp alltraps
8010727b:	e9 43 f7 ff ff       	jmp    801069c3 <alltraps>

80107280 <vector33>:
.globl vector33
vector33:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $33
80107282:	6a 21                	push   $0x21
  jmp alltraps
80107284:	e9 3a f7 ff ff       	jmp    801069c3 <alltraps>

80107289 <vector34>:
.globl vector34
vector34:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $34
8010728b:	6a 22                	push   $0x22
  jmp alltraps
8010728d:	e9 31 f7 ff ff       	jmp    801069c3 <alltraps>

80107292 <vector35>:
.globl vector35
vector35:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $35
80107294:	6a 23                	push   $0x23
  jmp alltraps
80107296:	e9 28 f7 ff ff       	jmp    801069c3 <alltraps>

8010729b <vector36>:
.globl vector36
vector36:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $36
8010729d:	6a 24                	push   $0x24
  jmp alltraps
8010729f:	e9 1f f7 ff ff       	jmp    801069c3 <alltraps>

801072a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $37
801072a6:	6a 25                	push   $0x25
  jmp alltraps
801072a8:	e9 16 f7 ff ff       	jmp    801069c3 <alltraps>

801072ad <vector38>:
.globl vector38
vector38:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $38
801072af:	6a 26                	push   $0x26
  jmp alltraps
801072b1:	e9 0d f7 ff ff       	jmp    801069c3 <alltraps>

801072b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $39
801072b8:	6a 27                	push   $0x27
  jmp alltraps
801072ba:	e9 04 f7 ff ff       	jmp    801069c3 <alltraps>

801072bf <vector40>:
.globl vector40
vector40:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $40
801072c1:	6a 28                	push   $0x28
  jmp alltraps
801072c3:	e9 fb f6 ff ff       	jmp    801069c3 <alltraps>

801072c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $41
801072ca:	6a 29                	push   $0x29
  jmp alltraps
801072cc:	e9 f2 f6 ff ff       	jmp    801069c3 <alltraps>

801072d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $42
801072d3:	6a 2a                	push   $0x2a
  jmp alltraps
801072d5:	e9 e9 f6 ff ff       	jmp    801069c3 <alltraps>

801072da <vector43>:
.globl vector43
vector43:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $43
801072dc:	6a 2b                	push   $0x2b
  jmp alltraps
801072de:	e9 e0 f6 ff ff       	jmp    801069c3 <alltraps>

801072e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $44
801072e5:	6a 2c                	push   $0x2c
  jmp alltraps
801072e7:	e9 d7 f6 ff ff       	jmp    801069c3 <alltraps>

801072ec <vector45>:
.globl vector45
vector45:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $45
801072ee:	6a 2d                	push   $0x2d
  jmp alltraps
801072f0:	e9 ce f6 ff ff       	jmp    801069c3 <alltraps>

801072f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $46
801072f7:	6a 2e                	push   $0x2e
  jmp alltraps
801072f9:	e9 c5 f6 ff ff       	jmp    801069c3 <alltraps>

801072fe <vector47>:
.globl vector47
vector47:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $47
80107300:	6a 2f                	push   $0x2f
  jmp alltraps
80107302:	e9 bc f6 ff ff       	jmp    801069c3 <alltraps>

80107307 <vector48>:
.globl vector48
vector48:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $48
80107309:	6a 30                	push   $0x30
  jmp alltraps
8010730b:	e9 b3 f6 ff ff       	jmp    801069c3 <alltraps>

80107310 <vector49>:
.globl vector49
vector49:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $49
80107312:	6a 31                	push   $0x31
  jmp alltraps
80107314:	e9 aa f6 ff ff       	jmp    801069c3 <alltraps>

80107319 <vector50>:
.globl vector50
vector50:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $50
8010731b:	6a 32                	push   $0x32
  jmp alltraps
8010731d:	e9 a1 f6 ff ff       	jmp    801069c3 <alltraps>

80107322 <vector51>:
.globl vector51
vector51:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $51
80107324:	6a 33                	push   $0x33
  jmp alltraps
80107326:	e9 98 f6 ff ff       	jmp    801069c3 <alltraps>

8010732b <vector52>:
.globl vector52
vector52:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $52
8010732d:	6a 34                	push   $0x34
  jmp alltraps
8010732f:	e9 8f f6 ff ff       	jmp    801069c3 <alltraps>

80107334 <vector53>:
.globl vector53
vector53:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $53
80107336:	6a 35                	push   $0x35
  jmp alltraps
80107338:	e9 86 f6 ff ff       	jmp    801069c3 <alltraps>

8010733d <vector54>:
.globl vector54
vector54:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $54
8010733f:	6a 36                	push   $0x36
  jmp alltraps
80107341:	e9 7d f6 ff ff       	jmp    801069c3 <alltraps>

80107346 <vector55>:
.globl vector55
vector55:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $55
80107348:	6a 37                	push   $0x37
  jmp alltraps
8010734a:	e9 74 f6 ff ff       	jmp    801069c3 <alltraps>

8010734f <vector56>:
.globl vector56
vector56:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $56
80107351:	6a 38                	push   $0x38
  jmp alltraps
80107353:	e9 6b f6 ff ff       	jmp    801069c3 <alltraps>

80107358 <vector57>:
.globl vector57
vector57:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $57
8010735a:	6a 39                	push   $0x39
  jmp alltraps
8010735c:	e9 62 f6 ff ff       	jmp    801069c3 <alltraps>

80107361 <vector58>:
.globl vector58
vector58:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $58
80107363:	6a 3a                	push   $0x3a
  jmp alltraps
80107365:	e9 59 f6 ff ff       	jmp    801069c3 <alltraps>

8010736a <vector59>:
.globl vector59
vector59:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $59
8010736c:	6a 3b                	push   $0x3b
  jmp alltraps
8010736e:	e9 50 f6 ff ff       	jmp    801069c3 <alltraps>

80107373 <vector60>:
.globl vector60
vector60:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $60
80107375:	6a 3c                	push   $0x3c
  jmp alltraps
80107377:	e9 47 f6 ff ff       	jmp    801069c3 <alltraps>

8010737c <vector61>:
.globl vector61
vector61:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $61
8010737e:	6a 3d                	push   $0x3d
  jmp alltraps
80107380:	e9 3e f6 ff ff       	jmp    801069c3 <alltraps>

80107385 <vector62>:
.globl vector62
vector62:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $62
80107387:	6a 3e                	push   $0x3e
  jmp alltraps
80107389:	e9 35 f6 ff ff       	jmp    801069c3 <alltraps>

8010738e <vector63>:
.globl vector63
vector63:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $63
80107390:	6a 3f                	push   $0x3f
  jmp alltraps
80107392:	e9 2c f6 ff ff       	jmp    801069c3 <alltraps>

80107397 <vector64>:
.globl vector64
vector64:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $64
80107399:	6a 40                	push   $0x40
  jmp alltraps
8010739b:	e9 23 f6 ff ff       	jmp    801069c3 <alltraps>

801073a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $65
801073a2:	6a 41                	push   $0x41
  jmp alltraps
801073a4:	e9 1a f6 ff ff       	jmp    801069c3 <alltraps>

801073a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $66
801073ab:	6a 42                	push   $0x42
  jmp alltraps
801073ad:	e9 11 f6 ff ff       	jmp    801069c3 <alltraps>

801073b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $67
801073b4:	6a 43                	push   $0x43
  jmp alltraps
801073b6:	e9 08 f6 ff ff       	jmp    801069c3 <alltraps>

801073bb <vector68>:
.globl vector68
vector68:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $68
801073bd:	6a 44                	push   $0x44
  jmp alltraps
801073bf:	e9 ff f5 ff ff       	jmp    801069c3 <alltraps>

801073c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $69
801073c6:	6a 45                	push   $0x45
  jmp alltraps
801073c8:	e9 f6 f5 ff ff       	jmp    801069c3 <alltraps>

801073cd <vector70>:
.globl vector70
vector70:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $70
801073cf:	6a 46                	push   $0x46
  jmp alltraps
801073d1:	e9 ed f5 ff ff       	jmp    801069c3 <alltraps>

801073d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $71
801073d8:	6a 47                	push   $0x47
  jmp alltraps
801073da:	e9 e4 f5 ff ff       	jmp    801069c3 <alltraps>

801073df <vector72>:
.globl vector72
vector72:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $72
801073e1:	6a 48                	push   $0x48
  jmp alltraps
801073e3:	e9 db f5 ff ff       	jmp    801069c3 <alltraps>

801073e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $73
801073ea:	6a 49                	push   $0x49
  jmp alltraps
801073ec:	e9 d2 f5 ff ff       	jmp    801069c3 <alltraps>

801073f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $74
801073f3:	6a 4a                	push   $0x4a
  jmp alltraps
801073f5:	e9 c9 f5 ff ff       	jmp    801069c3 <alltraps>

801073fa <vector75>:
.globl vector75
vector75:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $75
801073fc:	6a 4b                	push   $0x4b
  jmp alltraps
801073fe:	e9 c0 f5 ff ff       	jmp    801069c3 <alltraps>

80107403 <vector76>:
.globl vector76
vector76:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $76
80107405:	6a 4c                	push   $0x4c
  jmp alltraps
80107407:	e9 b7 f5 ff ff       	jmp    801069c3 <alltraps>

8010740c <vector77>:
.globl vector77
vector77:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $77
8010740e:	6a 4d                	push   $0x4d
  jmp alltraps
80107410:	e9 ae f5 ff ff       	jmp    801069c3 <alltraps>

80107415 <vector78>:
.globl vector78
vector78:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $78
80107417:	6a 4e                	push   $0x4e
  jmp alltraps
80107419:	e9 a5 f5 ff ff       	jmp    801069c3 <alltraps>

8010741e <vector79>:
.globl vector79
vector79:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $79
80107420:	6a 4f                	push   $0x4f
  jmp alltraps
80107422:	e9 9c f5 ff ff       	jmp    801069c3 <alltraps>

80107427 <vector80>:
.globl vector80
vector80:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $80
80107429:	6a 50                	push   $0x50
  jmp alltraps
8010742b:	e9 93 f5 ff ff       	jmp    801069c3 <alltraps>

80107430 <vector81>:
.globl vector81
vector81:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $81
80107432:	6a 51                	push   $0x51
  jmp alltraps
80107434:	e9 8a f5 ff ff       	jmp    801069c3 <alltraps>

80107439 <vector82>:
.globl vector82
vector82:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $82
8010743b:	6a 52                	push   $0x52
  jmp alltraps
8010743d:	e9 81 f5 ff ff       	jmp    801069c3 <alltraps>

80107442 <vector83>:
.globl vector83
vector83:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $83
80107444:	6a 53                	push   $0x53
  jmp alltraps
80107446:	e9 78 f5 ff ff       	jmp    801069c3 <alltraps>

8010744b <vector84>:
.globl vector84
vector84:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $84
8010744d:	6a 54                	push   $0x54
  jmp alltraps
8010744f:	e9 6f f5 ff ff       	jmp    801069c3 <alltraps>

80107454 <vector85>:
.globl vector85
vector85:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $85
80107456:	6a 55                	push   $0x55
  jmp alltraps
80107458:	e9 66 f5 ff ff       	jmp    801069c3 <alltraps>

8010745d <vector86>:
.globl vector86
vector86:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $86
8010745f:	6a 56                	push   $0x56
  jmp alltraps
80107461:	e9 5d f5 ff ff       	jmp    801069c3 <alltraps>

80107466 <vector87>:
.globl vector87
vector87:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $87
80107468:	6a 57                	push   $0x57
  jmp alltraps
8010746a:	e9 54 f5 ff ff       	jmp    801069c3 <alltraps>

8010746f <vector88>:
.globl vector88
vector88:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $88
80107471:	6a 58                	push   $0x58
  jmp alltraps
80107473:	e9 4b f5 ff ff       	jmp    801069c3 <alltraps>

80107478 <vector89>:
.globl vector89
vector89:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $89
8010747a:	6a 59                	push   $0x59
  jmp alltraps
8010747c:	e9 42 f5 ff ff       	jmp    801069c3 <alltraps>

80107481 <vector90>:
.globl vector90
vector90:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $90
80107483:	6a 5a                	push   $0x5a
  jmp alltraps
80107485:	e9 39 f5 ff ff       	jmp    801069c3 <alltraps>

8010748a <vector91>:
.globl vector91
vector91:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $91
8010748c:	6a 5b                	push   $0x5b
  jmp alltraps
8010748e:	e9 30 f5 ff ff       	jmp    801069c3 <alltraps>

80107493 <vector92>:
.globl vector92
vector92:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $92
80107495:	6a 5c                	push   $0x5c
  jmp alltraps
80107497:	e9 27 f5 ff ff       	jmp    801069c3 <alltraps>

8010749c <vector93>:
.globl vector93
vector93:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $93
8010749e:	6a 5d                	push   $0x5d
  jmp alltraps
801074a0:	e9 1e f5 ff ff       	jmp    801069c3 <alltraps>

801074a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $94
801074a7:	6a 5e                	push   $0x5e
  jmp alltraps
801074a9:	e9 15 f5 ff ff       	jmp    801069c3 <alltraps>

801074ae <vector95>:
.globl vector95
vector95:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $95
801074b0:	6a 5f                	push   $0x5f
  jmp alltraps
801074b2:	e9 0c f5 ff ff       	jmp    801069c3 <alltraps>

801074b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $96
801074b9:	6a 60                	push   $0x60
  jmp alltraps
801074bb:	e9 03 f5 ff ff       	jmp    801069c3 <alltraps>

801074c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $97
801074c2:	6a 61                	push   $0x61
  jmp alltraps
801074c4:	e9 fa f4 ff ff       	jmp    801069c3 <alltraps>

801074c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $98
801074cb:	6a 62                	push   $0x62
  jmp alltraps
801074cd:	e9 f1 f4 ff ff       	jmp    801069c3 <alltraps>

801074d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $99
801074d4:	6a 63                	push   $0x63
  jmp alltraps
801074d6:	e9 e8 f4 ff ff       	jmp    801069c3 <alltraps>

801074db <vector100>:
.globl vector100
vector100:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $100
801074dd:	6a 64                	push   $0x64
  jmp alltraps
801074df:	e9 df f4 ff ff       	jmp    801069c3 <alltraps>

801074e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $101
801074e6:	6a 65                	push   $0x65
  jmp alltraps
801074e8:	e9 d6 f4 ff ff       	jmp    801069c3 <alltraps>

801074ed <vector102>:
.globl vector102
vector102:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $102
801074ef:	6a 66                	push   $0x66
  jmp alltraps
801074f1:	e9 cd f4 ff ff       	jmp    801069c3 <alltraps>

801074f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $103
801074f8:	6a 67                	push   $0x67
  jmp alltraps
801074fa:	e9 c4 f4 ff ff       	jmp    801069c3 <alltraps>

801074ff <vector104>:
.globl vector104
vector104:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $104
80107501:	6a 68                	push   $0x68
  jmp alltraps
80107503:	e9 bb f4 ff ff       	jmp    801069c3 <alltraps>

80107508 <vector105>:
.globl vector105
vector105:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $105
8010750a:	6a 69                	push   $0x69
  jmp alltraps
8010750c:	e9 b2 f4 ff ff       	jmp    801069c3 <alltraps>

80107511 <vector106>:
.globl vector106
vector106:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $106
80107513:	6a 6a                	push   $0x6a
  jmp alltraps
80107515:	e9 a9 f4 ff ff       	jmp    801069c3 <alltraps>

8010751a <vector107>:
.globl vector107
vector107:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $107
8010751c:	6a 6b                	push   $0x6b
  jmp alltraps
8010751e:	e9 a0 f4 ff ff       	jmp    801069c3 <alltraps>

80107523 <vector108>:
.globl vector108
vector108:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $108
80107525:	6a 6c                	push   $0x6c
  jmp alltraps
80107527:	e9 97 f4 ff ff       	jmp    801069c3 <alltraps>

8010752c <vector109>:
.globl vector109
vector109:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $109
8010752e:	6a 6d                	push   $0x6d
  jmp alltraps
80107530:	e9 8e f4 ff ff       	jmp    801069c3 <alltraps>

80107535 <vector110>:
.globl vector110
vector110:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $110
80107537:	6a 6e                	push   $0x6e
  jmp alltraps
80107539:	e9 85 f4 ff ff       	jmp    801069c3 <alltraps>

8010753e <vector111>:
.globl vector111
vector111:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $111
80107540:	6a 6f                	push   $0x6f
  jmp alltraps
80107542:	e9 7c f4 ff ff       	jmp    801069c3 <alltraps>

80107547 <vector112>:
.globl vector112
vector112:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $112
80107549:	6a 70                	push   $0x70
  jmp alltraps
8010754b:	e9 73 f4 ff ff       	jmp    801069c3 <alltraps>

80107550 <vector113>:
.globl vector113
vector113:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $113
80107552:	6a 71                	push   $0x71
  jmp alltraps
80107554:	e9 6a f4 ff ff       	jmp    801069c3 <alltraps>

80107559 <vector114>:
.globl vector114
vector114:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $114
8010755b:	6a 72                	push   $0x72
  jmp alltraps
8010755d:	e9 61 f4 ff ff       	jmp    801069c3 <alltraps>

80107562 <vector115>:
.globl vector115
vector115:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $115
80107564:	6a 73                	push   $0x73
  jmp alltraps
80107566:	e9 58 f4 ff ff       	jmp    801069c3 <alltraps>

8010756b <vector116>:
.globl vector116
vector116:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $116
8010756d:	6a 74                	push   $0x74
  jmp alltraps
8010756f:	e9 4f f4 ff ff       	jmp    801069c3 <alltraps>

80107574 <vector117>:
.globl vector117
vector117:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $117
80107576:	6a 75                	push   $0x75
  jmp alltraps
80107578:	e9 46 f4 ff ff       	jmp    801069c3 <alltraps>

8010757d <vector118>:
.globl vector118
vector118:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $118
8010757f:	6a 76                	push   $0x76
  jmp alltraps
80107581:	e9 3d f4 ff ff       	jmp    801069c3 <alltraps>

80107586 <vector119>:
.globl vector119
vector119:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $119
80107588:	6a 77                	push   $0x77
  jmp alltraps
8010758a:	e9 34 f4 ff ff       	jmp    801069c3 <alltraps>

8010758f <vector120>:
.globl vector120
vector120:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $120
80107591:	6a 78                	push   $0x78
  jmp alltraps
80107593:	e9 2b f4 ff ff       	jmp    801069c3 <alltraps>

80107598 <vector121>:
.globl vector121
vector121:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $121
8010759a:	6a 79                	push   $0x79
  jmp alltraps
8010759c:	e9 22 f4 ff ff       	jmp    801069c3 <alltraps>

801075a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $122
801075a3:	6a 7a                	push   $0x7a
  jmp alltraps
801075a5:	e9 19 f4 ff ff       	jmp    801069c3 <alltraps>

801075aa <vector123>:
.globl vector123
vector123:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $123
801075ac:	6a 7b                	push   $0x7b
  jmp alltraps
801075ae:	e9 10 f4 ff ff       	jmp    801069c3 <alltraps>

801075b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $124
801075b5:	6a 7c                	push   $0x7c
  jmp alltraps
801075b7:	e9 07 f4 ff ff       	jmp    801069c3 <alltraps>

801075bc <vector125>:
.globl vector125
vector125:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $125
801075be:	6a 7d                	push   $0x7d
  jmp alltraps
801075c0:	e9 fe f3 ff ff       	jmp    801069c3 <alltraps>

801075c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $126
801075c7:	6a 7e                	push   $0x7e
  jmp alltraps
801075c9:	e9 f5 f3 ff ff       	jmp    801069c3 <alltraps>

801075ce <vector127>:
.globl vector127
vector127:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $127
801075d0:	6a 7f                	push   $0x7f
  jmp alltraps
801075d2:	e9 ec f3 ff ff       	jmp    801069c3 <alltraps>

801075d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $128
801075d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801075de:	e9 e0 f3 ff ff       	jmp    801069c3 <alltraps>

801075e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $129
801075e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801075ea:	e9 d4 f3 ff ff       	jmp    801069c3 <alltraps>

801075ef <vector130>:
.globl vector130
vector130:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $130
801075f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801075f6:	e9 c8 f3 ff ff       	jmp    801069c3 <alltraps>

801075fb <vector131>:
.globl vector131
vector131:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $131
801075fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107602:	e9 bc f3 ff ff       	jmp    801069c3 <alltraps>

80107607 <vector132>:
.globl vector132
vector132:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $132
80107609:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010760e:	e9 b0 f3 ff ff       	jmp    801069c3 <alltraps>

80107613 <vector133>:
.globl vector133
vector133:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $133
80107615:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010761a:	e9 a4 f3 ff ff       	jmp    801069c3 <alltraps>

8010761f <vector134>:
.globl vector134
vector134:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $134
80107621:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107626:	e9 98 f3 ff ff       	jmp    801069c3 <alltraps>

8010762b <vector135>:
.globl vector135
vector135:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $135
8010762d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107632:	e9 8c f3 ff ff       	jmp    801069c3 <alltraps>

80107637 <vector136>:
.globl vector136
vector136:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $136
80107639:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010763e:	e9 80 f3 ff ff       	jmp    801069c3 <alltraps>

80107643 <vector137>:
.globl vector137
vector137:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $137
80107645:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010764a:	e9 74 f3 ff ff       	jmp    801069c3 <alltraps>

8010764f <vector138>:
.globl vector138
vector138:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $138
80107651:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107656:	e9 68 f3 ff ff       	jmp    801069c3 <alltraps>

8010765b <vector139>:
.globl vector139
vector139:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $139
8010765d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107662:	e9 5c f3 ff ff       	jmp    801069c3 <alltraps>

80107667 <vector140>:
.globl vector140
vector140:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $140
80107669:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010766e:	e9 50 f3 ff ff       	jmp    801069c3 <alltraps>

80107673 <vector141>:
.globl vector141
vector141:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $141
80107675:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010767a:	e9 44 f3 ff ff       	jmp    801069c3 <alltraps>

8010767f <vector142>:
.globl vector142
vector142:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $142
80107681:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107686:	e9 38 f3 ff ff       	jmp    801069c3 <alltraps>

8010768b <vector143>:
.globl vector143
vector143:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $143
8010768d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107692:	e9 2c f3 ff ff       	jmp    801069c3 <alltraps>

80107697 <vector144>:
.globl vector144
vector144:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $144
80107699:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010769e:	e9 20 f3 ff ff       	jmp    801069c3 <alltraps>

801076a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $145
801076a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801076aa:	e9 14 f3 ff ff       	jmp    801069c3 <alltraps>

801076af <vector146>:
.globl vector146
vector146:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $146
801076b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801076b6:	e9 08 f3 ff ff       	jmp    801069c3 <alltraps>

801076bb <vector147>:
.globl vector147
vector147:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $147
801076bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801076c2:	e9 fc f2 ff ff       	jmp    801069c3 <alltraps>

801076c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $148
801076c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801076ce:	e9 f0 f2 ff ff       	jmp    801069c3 <alltraps>

801076d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $149
801076d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801076da:	e9 e4 f2 ff ff       	jmp    801069c3 <alltraps>

801076df <vector150>:
.globl vector150
vector150:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $150
801076e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801076e6:	e9 d8 f2 ff ff       	jmp    801069c3 <alltraps>

801076eb <vector151>:
.globl vector151
vector151:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $151
801076ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801076f2:	e9 cc f2 ff ff       	jmp    801069c3 <alltraps>

801076f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $152
801076f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801076fe:	e9 c0 f2 ff ff       	jmp    801069c3 <alltraps>

80107703 <vector153>:
.globl vector153
vector153:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $153
80107705:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010770a:	e9 b4 f2 ff ff       	jmp    801069c3 <alltraps>

8010770f <vector154>:
.globl vector154
vector154:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $154
80107711:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107716:	e9 a8 f2 ff ff       	jmp    801069c3 <alltraps>

8010771b <vector155>:
.globl vector155
vector155:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $155
8010771d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107722:	e9 9c f2 ff ff       	jmp    801069c3 <alltraps>

80107727 <vector156>:
.globl vector156
vector156:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $156
80107729:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010772e:	e9 90 f2 ff ff       	jmp    801069c3 <alltraps>

80107733 <vector157>:
.globl vector157
vector157:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $157
80107735:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010773a:	e9 84 f2 ff ff       	jmp    801069c3 <alltraps>

8010773f <vector158>:
.globl vector158
vector158:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $158
80107741:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107746:	e9 78 f2 ff ff       	jmp    801069c3 <alltraps>

8010774b <vector159>:
.globl vector159
vector159:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $159
8010774d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107752:	e9 6c f2 ff ff       	jmp    801069c3 <alltraps>

80107757 <vector160>:
.globl vector160
vector160:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $160
80107759:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010775e:	e9 60 f2 ff ff       	jmp    801069c3 <alltraps>

80107763 <vector161>:
.globl vector161
vector161:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $161
80107765:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010776a:	e9 54 f2 ff ff       	jmp    801069c3 <alltraps>

8010776f <vector162>:
.globl vector162
vector162:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $162
80107771:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107776:	e9 48 f2 ff ff       	jmp    801069c3 <alltraps>

8010777b <vector163>:
.globl vector163
vector163:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $163
8010777d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107782:	e9 3c f2 ff ff       	jmp    801069c3 <alltraps>

80107787 <vector164>:
.globl vector164
vector164:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $164
80107789:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010778e:	e9 30 f2 ff ff       	jmp    801069c3 <alltraps>

80107793 <vector165>:
.globl vector165
vector165:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $165
80107795:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010779a:	e9 24 f2 ff ff       	jmp    801069c3 <alltraps>

8010779f <vector166>:
.globl vector166
vector166:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $166
801077a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801077a6:	e9 18 f2 ff ff       	jmp    801069c3 <alltraps>

801077ab <vector167>:
.globl vector167
vector167:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $167
801077ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801077b2:	e9 0c f2 ff ff       	jmp    801069c3 <alltraps>

801077b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $168
801077b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801077be:	e9 00 f2 ff ff       	jmp    801069c3 <alltraps>

801077c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $169
801077c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801077ca:	e9 f4 f1 ff ff       	jmp    801069c3 <alltraps>

801077cf <vector170>:
.globl vector170
vector170:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $170
801077d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801077d6:	e9 e8 f1 ff ff       	jmp    801069c3 <alltraps>

801077db <vector171>:
.globl vector171
vector171:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $171
801077dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801077e2:	e9 dc f1 ff ff       	jmp    801069c3 <alltraps>

801077e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $172
801077e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801077ee:	e9 d0 f1 ff ff       	jmp    801069c3 <alltraps>

801077f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $173
801077f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801077fa:	e9 c4 f1 ff ff       	jmp    801069c3 <alltraps>

801077ff <vector174>:
.globl vector174
vector174:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $174
80107801:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107806:	e9 b8 f1 ff ff       	jmp    801069c3 <alltraps>

8010780b <vector175>:
.globl vector175
vector175:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $175
8010780d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107812:	e9 ac f1 ff ff       	jmp    801069c3 <alltraps>

80107817 <vector176>:
.globl vector176
vector176:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $176
80107819:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010781e:	e9 a0 f1 ff ff       	jmp    801069c3 <alltraps>

80107823 <vector177>:
.globl vector177
vector177:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $177
80107825:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010782a:	e9 94 f1 ff ff       	jmp    801069c3 <alltraps>

8010782f <vector178>:
.globl vector178
vector178:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $178
80107831:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107836:	e9 88 f1 ff ff       	jmp    801069c3 <alltraps>

8010783b <vector179>:
.globl vector179
vector179:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $179
8010783d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107842:	e9 7c f1 ff ff       	jmp    801069c3 <alltraps>

80107847 <vector180>:
.globl vector180
vector180:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $180
80107849:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010784e:	e9 70 f1 ff ff       	jmp    801069c3 <alltraps>

80107853 <vector181>:
.globl vector181
vector181:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $181
80107855:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010785a:	e9 64 f1 ff ff       	jmp    801069c3 <alltraps>

8010785f <vector182>:
.globl vector182
vector182:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $182
80107861:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107866:	e9 58 f1 ff ff       	jmp    801069c3 <alltraps>

8010786b <vector183>:
.globl vector183
vector183:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $183
8010786d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107872:	e9 4c f1 ff ff       	jmp    801069c3 <alltraps>

80107877 <vector184>:
.globl vector184
vector184:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $184
80107879:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010787e:	e9 40 f1 ff ff       	jmp    801069c3 <alltraps>

80107883 <vector185>:
.globl vector185
vector185:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $185
80107885:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010788a:	e9 34 f1 ff ff       	jmp    801069c3 <alltraps>

8010788f <vector186>:
.globl vector186
vector186:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $186
80107891:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107896:	e9 28 f1 ff ff       	jmp    801069c3 <alltraps>

8010789b <vector187>:
.globl vector187
vector187:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $187
8010789d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801078a2:	e9 1c f1 ff ff       	jmp    801069c3 <alltraps>

801078a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $188
801078a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801078ae:	e9 10 f1 ff ff       	jmp    801069c3 <alltraps>

801078b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $189
801078b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801078ba:	e9 04 f1 ff ff       	jmp    801069c3 <alltraps>

801078bf <vector190>:
.globl vector190
vector190:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $190
801078c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801078c6:	e9 f8 f0 ff ff       	jmp    801069c3 <alltraps>

801078cb <vector191>:
.globl vector191
vector191:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $191
801078cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801078d2:	e9 ec f0 ff ff       	jmp    801069c3 <alltraps>

801078d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $192
801078d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801078de:	e9 e0 f0 ff ff       	jmp    801069c3 <alltraps>

801078e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $193
801078e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801078ea:	e9 d4 f0 ff ff       	jmp    801069c3 <alltraps>

801078ef <vector194>:
.globl vector194
vector194:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $194
801078f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801078f6:	e9 c8 f0 ff ff       	jmp    801069c3 <alltraps>

801078fb <vector195>:
.globl vector195
vector195:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $195
801078fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107902:	e9 bc f0 ff ff       	jmp    801069c3 <alltraps>

80107907 <vector196>:
.globl vector196
vector196:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $196
80107909:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010790e:	e9 b0 f0 ff ff       	jmp    801069c3 <alltraps>

80107913 <vector197>:
.globl vector197
vector197:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $197
80107915:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010791a:	e9 a4 f0 ff ff       	jmp    801069c3 <alltraps>

8010791f <vector198>:
.globl vector198
vector198:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $198
80107921:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107926:	e9 98 f0 ff ff       	jmp    801069c3 <alltraps>

8010792b <vector199>:
.globl vector199
vector199:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $199
8010792d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107932:	e9 8c f0 ff ff       	jmp    801069c3 <alltraps>

80107937 <vector200>:
.globl vector200
vector200:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $200
80107939:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010793e:	e9 80 f0 ff ff       	jmp    801069c3 <alltraps>

80107943 <vector201>:
.globl vector201
vector201:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $201
80107945:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010794a:	e9 74 f0 ff ff       	jmp    801069c3 <alltraps>

8010794f <vector202>:
.globl vector202
vector202:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $202
80107951:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107956:	e9 68 f0 ff ff       	jmp    801069c3 <alltraps>

8010795b <vector203>:
.globl vector203
vector203:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $203
8010795d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107962:	e9 5c f0 ff ff       	jmp    801069c3 <alltraps>

80107967 <vector204>:
.globl vector204
vector204:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $204
80107969:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010796e:	e9 50 f0 ff ff       	jmp    801069c3 <alltraps>

80107973 <vector205>:
.globl vector205
vector205:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $205
80107975:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010797a:	e9 44 f0 ff ff       	jmp    801069c3 <alltraps>

8010797f <vector206>:
.globl vector206
vector206:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $206
80107981:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107986:	e9 38 f0 ff ff       	jmp    801069c3 <alltraps>

8010798b <vector207>:
.globl vector207
vector207:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $207
8010798d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107992:	e9 2c f0 ff ff       	jmp    801069c3 <alltraps>

80107997 <vector208>:
.globl vector208
vector208:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $208
80107999:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010799e:	e9 20 f0 ff ff       	jmp    801069c3 <alltraps>

801079a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $209
801079a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801079aa:	e9 14 f0 ff ff       	jmp    801069c3 <alltraps>

801079af <vector210>:
.globl vector210
vector210:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $210
801079b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801079b6:	e9 08 f0 ff ff       	jmp    801069c3 <alltraps>

801079bb <vector211>:
.globl vector211
vector211:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $211
801079bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801079c2:	e9 fc ef ff ff       	jmp    801069c3 <alltraps>

801079c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $212
801079c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801079ce:	e9 f0 ef ff ff       	jmp    801069c3 <alltraps>

801079d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $213
801079d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801079da:	e9 e4 ef ff ff       	jmp    801069c3 <alltraps>

801079df <vector214>:
.globl vector214
vector214:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $214
801079e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801079e6:	e9 d8 ef ff ff       	jmp    801069c3 <alltraps>

801079eb <vector215>:
.globl vector215
vector215:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $215
801079ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801079f2:	e9 cc ef ff ff       	jmp    801069c3 <alltraps>

801079f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $216
801079f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801079fe:	e9 c0 ef ff ff       	jmp    801069c3 <alltraps>

80107a03 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $217
80107a05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a0a:	e9 b4 ef ff ff       	jmp    801069c3 <alltraps>

80107a0f <vector218>:
.globl vector218
vector218:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $218
80107a11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a16:	e9 a8 ef ff ff       	jmp    801069c3 <alltraps>

80107a1b <vector219>:
.globl vector219
vector219:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $219
80107a1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a22:	e9 9c ef ff ff       	jmp    801069c3 <alltraps>

80107a27 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $220
80107a29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a2e:	e9 90 ef ff ff       	jmp    801069c3 <alltraps>

80107a33 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $221
80107a35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a3a:	e9 84 ef ff ff       	jmp    801069c3 <alltraps>

80107a3f <vector222>:
.globl vector222
vector222:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $222
80107a41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a46:	e9 78 ef ff ff       	jmp    801069c3 <alltraps>

80107a4b <vector223>:
.globl vector223
vector223:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $223
80107a4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a52:	e9 6c ef ff ff       	jmp    801069c3 <alltraps>

80107a57 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $224
80107a59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a5e:	e9 60 ef ff ff       	jmp    801069c3 <alltraps>

80107a63 <vector225>:
.globl vector225
vector225:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $225
80107a65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a6a:	e9 54 ef ff ff       	jmp    801069c3 <alltraps>

80107a6f <vector226>:
.globl vector226
vector226:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $226
80107a71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a76:	e9 48 ef ff ff       	jmp    801069c3 <alltraps>

80107a7b <vector227>:
.globl vector227
vector227:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $227
80107a7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a82:	e9 3c ef ff ff       	jmp    801069c3 <alltraps>

80107a87 <vector228>:
.globl vector228
vector228:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $228
80107a89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a8e:	e9 30 ef ff ff       	jmp    801069c3 <alltraps>

80107a93 <vector229>:
.globl vector229
vector229:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $229
80107a95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a9a:	e9 24 ef ff ff       	jmp    801069c3 <alltraps>

80107a9f <vector230>:
.globl vector230
vector230:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $230
80107aa1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107aa6:	e9 18 ef ff ff       	jmp    801069c3 <alltraps>

80107aab <vector231>:
.globl vector231
vector231:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $231
80107aad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107ab2:	e9 0c ef ff ff       	jmp    801069c3 <alltraps>

80107ab7 <vector232>:
.globl vector232
vector232:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $232
80107ab9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107abe:	e9 00 ef ff ff       	jmp    801069c3 <alltraps>

80107ac3 <vector233>:
.globl vector233
vector233:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $233
80107ac5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107aca:	e9 f4 ee ff ff       	jmp    801069c3 <alltraps>

80107acf <vector234>:
.globl vector234
vector234:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $234
80107ad1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107ad6:	e9 e8 ee ff ff       	jmp    801069c3 <alltraps>

80107adb <vector235>:
.globl vector235
vector235:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $235
80107add:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107ae2:	e9 dc ee ff ff       	jmp    801069c3 <alltraps>

80107ae7 <vector236>:
.globl vector236
vector236:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $236
80107ae9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107aee:	e9 d0 ee ff ff       	jmp    801069c3 <alltraps>

80107af3 <vector237>:
.globl vector237
vector237:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $237
80107af5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107afa:	e9 c4 ee ff ff       	jmp    801069c3 <alltraps>

80107aff <vector238>:
.globl vector238
vector238:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $238
80107b01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b06:	e9 b8 ee ff ff       	jmp    801069c3 <alltraps>

80107b0b <vector239>:
.globl vector239
vector239:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $239
80107b0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b12:	e9 ac ee ff ff       	jmp    801069c3 <alltraps>

80107b17 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $240
80107b19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b1e:	e9 a0 ee ff ff       	jmp    801069c3 <alltraps>

80107b23 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $241
80107b25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b2a:	e9 94 ee ff ff       	jmp    801069c3 <alltraps>

80107b2f <vector242>:
.globl vector242
vector242:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $242
80107b31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b36:	e9 88 ee ff ff       	jmp    801069c3 <alltraps>

80107b3b <vector243>:
.globl vector243
vector243:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $243
80107b3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b42:	e9 7c ee ff ff       	jmp    801069c3 <alltraps>

80107b47 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $244
80107b49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b4e:	e9 70 ee ff ff       	jmp    801069c3 <alltraps>

80107b53 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $245
80107b55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b5a:	e9 64 ee ff ff       	jmp    801069c3 <alltraps>

80107b5f <vector246>:
.globl vector246
vector246:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $246
80107b61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b66:	e9 58 ee ff ff       	jmp    801069c3 <alltraps>

80107b6b <vector247>:
.globl vector247
vector247:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $247
80107b6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107b72:	e9 4c ee ff ff       	jmp    801069c3 <alltraps>

80107b77 <vector248>:
.globl vector248
vector248:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $248
80107b79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b7e:	e9 40 ee ff ff       	jmp    801069c3 <alltraps>

80107b83 <vector249>:
.globl vector249
vector249:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $249
80107b85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b8a:	e9 34 ee ff ff       	jmp    801069c3 <alltraps>

80107b8f <vector250>:
.globl vector250
vector250:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $250
80107b91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b96:	e9 28 ee ff ff       	jmp    801069c3 <alltraps>

80107b9b <vector251>:
.globl vector251
vector251:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $251
80107b9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107ba2:	e9 1c ee ff ff       	jmp    801069c3 <alltraps>

80107ba7 <vector252>:
.globl vector252
vector252:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $252
80107ba9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107bae:	e9 10 ee ff ff       	jmp    801069c3 <alltraps>

80107bb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $253
80107bb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107bba:	e9 04 ee ff ff       	jmp    801069c3 <alltraps>

80107bbf <vector254>:
.globl vector254
vector254:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $254
80107bc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107bc6:	e9 f8 ed ff ff       	jmp    801069c3 <alltraps>

80107bcb <vector255>:
.globl vector255
vector255:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $255
80107bcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107bd2:	e9 ec ed ff ff       	jmp    801069c3 <alltraps>
80107bd7:	66 90                	xchg   %ax,%ax
80107bd9:	66 90                	xchg   %ax,%ax
80107bdb:	66 90                	xchg   %ax,%ax
80107bdd:	66 90                	xchg   %ax,%ax
80107bdf:	90                   	nop

80107be0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107be6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107bec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107bf2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80107bf5:	39 d3                	cmp    %edx,%ebx
80107bf7:	73 56                	jae    80107c4f <deallocuvm.part.0+0x6f>
80107bf9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107bfc:	89 c6                	mov    %eax,%esi
80107bfe:	89 d7                	mov    %edx,%edi
80107c00:	eb 12                	jmp    80107c14 <deallocuvm.part.0+0x34>
80107c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c08:	83 c2 01             	add    $0x1,%edx
80107c0b:	89 d3                	mov    %edx,%ebx
80107c0d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107c10:	39 fb                	cmp    %edi,%ebx
80107c12:	73 38                	jae    80107c4c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80107c14:	89 da                	mov    %ebx,%edx
80107c16:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107c19:	8b 04 96             	mov    (%esi,%edx,4),%eax
80107c1c:	a8 01                	test   $0x1,%al
80107c1e:	74 e8                	je     80107c08 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80107c20:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107c27:	c1 e9 0a             	shr    $0xa,%ecx
80107c2a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107c30:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80107c37:	85 c0                	test   %eax,%eax
80107c39:	74 cd                	je     80107c08 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80107c3b:	8b 10                	mov    (%eax),%edx
80107c3d:	f6 c2 01             	test   $0x1,%dl
80107c40:	75 1e                	jne    80107c60 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80107c42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c48:	39 fb                	cmp    %edi,%ebx
80107c4a:	72 c8                	jb     80107c14 <deallocuvm.part.0+0x34>
80107c4c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c52:	89 c8                	mov    %ecx,%eax
80107c54:	5b                   	pop    %ebx
80107c55:	5e                   	pop    %esi
80107c56:	5f                   	pop    %edi
80107c57:	5d                   	pop    %ebp
80107c58:	c3                   	ret
80107c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80107c60:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107c66:	74 26                	je     80107c8e <deallocuvm.part.0+0xae>
      kfree(v);
80107c68:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107c6b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107c7a:	52                   	push   %edx
80107c7b:	e8 20 a8 ff ff       	call   801024a0 <kfree>
      *pte = 0;
80107c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80107c83:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107c86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107c8c:	eb 82                	jmp    80107c10 <deallocuvm.part.0+0x30>
        panic("kfree");
80107c8e:	83 ec 0c             	sub    $0xc,%esp
80107c91:	68 0c 88 10 80       	push   $0x8010880c
80107c96:	e8 e5 86 ff ff       	call   80100380 <panic>
80107c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c9f:	90                   	nop

80107ca0 <seginit>:
{
80107ca0:	55                   	push   %ebp
80107ca1:	89 e5                	mov    %esp,%ebp
80107ca3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107ca6:	e8 95 bc ff ff       	call   80103940 <cpuid>
  pd[0] = size-1;
80107cab:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107cb0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107cb6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80107cba:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107cc1:	ff 00 00 
80107cc4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80107ccb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107cce:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107cd5:	ff 00 00 
80107cd8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80107cdf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ce2:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107ce9:	ff 00 00 
80107cec:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107cf3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107cf6:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80107cfd:	ff 00 00 
80107d00:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107d07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107d0a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80107d0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107d13:	c1 e8 10             	shr    $0x10,%eax
80107d16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107d1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107d1d:	0f 01 10             	lgdtl  (%eax)
}
80107d20:	c9                   	leave
80107d21:	c3                   	ret
80107d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d30 <walkpgdir>:
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	57                   	push   %edi
80107d34:	56                   	push   %esi
80107d35:	53                   	push   %ebx
80107d36:	83 ec 0c             	sub    $0xc,%esp
80107d39:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80107d3c:	8b 55 08             	mov    0x8(%ebp),%edx
80107d3f:	89 fe                	mov    %edi,%esi
80107d41:	c1 ee 16             	shr    $0x16,%esi
80107d44:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80107d47:	8b 1e                	mov    (%esi),%ebx
80107d49:	f6 c3 01             	test   $0x1,%bl
80107d4c:	74 22                	je     80107d70 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107d54:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80107d5a:	89 f8                	mov    %edi,%eax
}
80107d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107d5f:	c1 e8 0a             	shr    $0xa,%eax
80107d62:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d67:	01 d8                	add    %ebx,%eax
}
80107d69:	5b                   	pop    %ebx
80107d6a:	5e                   	pop    %esi
80107d6b:	5f                   	pop    %edi
80107d6c:	5d                   	pop    %ebp
80107d6d:	c3                   	ret
80107d6e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d70:	8b 45 10             	mov    0x10(%ebp),%eax
80107d73:	85 c0                	test   %eax,%eax
80107d75:	74 31                	je     80107da8 <walkpgdir+0x78>
80107d77:	e8 e4 a8 ff ff       	call   80102660 <kalloc>
80107d7c:	89 c3                	mov    %eax,%ebx
80107d7e:	85 c0                	test   %eax,%eax
80107d80:	74 26                	je     80107da8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80107d82:	83 ec 04             	sub    $0x4,%esp
80107d85:	68 00 10 00 00       	push   $0x1000
80107d8a:	6a 00                	push   $0x0
80107d8c:	50                   	push   %eax
80107d8d:	e8 5e cc ff ff       	call   801049f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107d92:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d98:	83 c4 10             	add    $0x10,%esp
80107d9b:	83 c8 07             	or     $0x7,%eax
80107d9e:	89 06                	mov    %eax,(%esi)
80107da0:	eb b8                	jmp    80107d5a <walkpgdir+0x2a>
80107da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107dab:	31 c0                	xor    %eax,%eax
}
80107dad:	5b                   	pop    %ebx
80107dae:	5e                   	pop    %esi
80107daf:	5f                   	pop    %edi
80107db0:	5d                   	pop    %ebp
80107db1:	c3                   	ret
80107db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107dc0 <mappages>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	56                   	push   %esi
80107dc5:	53                   	push   %ebx
80107dc6:	83 ec 1c             	sub    $0x1c,%esp
80107dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107dcc:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
80107dcf:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107dd1:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80107dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107dda:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107de0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107de3:	8b 45 14             	mov    0x14(%ebp),%eax
80107de6:	29 d8                	sub    %ebx,%eax
80107de8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107deb:	eb 3c                	jmp    80107e29 <mappages+0x69>
80107ded:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107df0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107df7:	c1 ea 0a             	shr    $0xa,%edx
80107dfa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107e00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107e07:	85 c0                	test   %eax,%eax
80107e09:	74 75                	je     80107e80 <mappages+0xc0>
    if(*pte & PTE_P)
80107e0b:	f6 00 01             	testb  $0x1,(%eax)
80107e0e:	0f 85 86 00 00 00    	jne    80107e9a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107e14:	0b 75 18             	or     0x18(%ebp),%esi
80107e17:	83 ce 01             	or     $0x1,%esi
80107e1a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e1f:	39 c3                	cmp    %eax,%ebx
80107e21:	74 6d                	je     80107e90 <mappages+0xd0>
    a += PGSIZE;
80107e23:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107e2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107e2f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80107e32:	89 d8                	mov    %ebx,%eax
80107e34:	c1 e8 16             	shr    $0x16,%eax
80107e37:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107e3a:	8b 07                	mov    (%edi),%eax
80107e3c:	a8 01                	test   $0x1,%al
80107e3e:	75 b0                	jne    80107df0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107e40:	e8 1b a8 ff ff       	call   80102660 <kalloc>
80107e45:	85 c0                	test   %eax,%eax
80107e47:	74 37                	je     80107e80 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107e49:	83 ec 04             	sub    $0x4,%esp
80107e4c:	68 00 10 00 00       	push   $0x1000
80107e51:	6a 00                	push   $0x0
80107e53:	50                   	push   %eax
80107e54:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e57:	e8 94 cb ff ff       	call   801049f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80107e5f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107e62:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107e68:	83 c8 07             	or     $0x7,%eax
80107e6b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107e6d:	89 d8                	mov    %ebx,%eax
80107e6f:	c1 e8 0a             	shr    $0xa,%eax
80107e72:	25 fc 0f 00 00       	and    $0xffc,%eax
80107e77:	01 d0                	add    %edx,%eax
80107e79:	eb 90                	jmp    80107e0b <mappages+0x4b>
80107e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e7f:	90                   	nop
}
80107e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e88:	5b                   	pop    %ebx
80107e89:	5e                   	pop    %esi
80107e8a:	5f                   	pop    %edi
80107e8b:	5d                   	pop    %ebp
80107e8c:	c3                   	ret
80107e8d:	8d 76 00             	lea    0x0(%esi),%esi
80107e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
 return 0;
80107e93:	31 c0                	xor    %eax,%eax
}
80107e95:	5b                   	pop    %ebx
80107e96:	5e                   	pop    %esi
80107e97:	5f                   	pop    %edi
80107e98:	5d                   	pop    %ebp
80107e99:	c3                   	ret
      panic("remap");
80107e9a:	83 ec 0c             	sub    $0xc,%esp
80107e9d:	68 a5 8a 10 80       	push   $0x80108aa5
80107ea2:	e8 d9 84 ff ff       	call   80100380 <panic>
80107ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eae:	66 90                	xchg   %ax,%ax

80107eb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107eb0:	a1 c4 04 15 80       	mov    0x801504c4,%eax
80107eb5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107eba:	0f 22 d8             	mov    %eax,%cr3
}
80107ebd:	c3                   	ret
80107ebe:	66 90                	xchg   %ax,%ax

80107ec0 <switchuvm>:
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 1c             	sub    $0x1c,%esp
80107ec9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107ecc:	85 f6                	test   %esi,%esi
80107ece:	0f 84 cb 00 00 00    	je     80107f9f <switchuvm+0xdf>
  if(p->kstack == 0)
80107ed4:	8b 46 08             	mov    0x8(%esi),%eax
80107ed7:	85 c0                	test   %eax,%eax
80107ed9:	0f 84 da 00 00 00    	je     80107fb9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107edf:	8b 46 04             	mov    0x4(%esi),%eax
80107ee2:	85 c0                	test   %eax,%eax
80107ee4:	0f 84 c2 00 00 00    	je     80107fac <switchuvm+0xec>
  pushcli();
80107eea:	e8 b1 c8 ff ff       	call   801047a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107eef:	e8 ec b9 ff ff       	call   801038e0 <mycpu>
80107ef4:	89 c3                	mov    %eax,%ebx
80107ef6:	e8 e5 b9 ff ff       	call   801038e0 <mycpu>
80107efb:	89 c7                	mov    %eax,%edi
80107efd:	e8 de b9 ff ff       	call   801038e0 <mycpu>
80107f02:	83 c7 08             	add    $0x8,%edi
80107f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f08:	e8 d3 b9 ff ff       	call   801038e0 <mycpu>
80107f0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107f10:	ba 67 00 00 00       	mov    $0x67,%edx
80107f15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107f1c:	83 c0 08             	add    $0x8,%eax
80107f1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107f2b:	83 c1 08             	add    $0x8,%ecx
80107f2e:	c1 e8 18             	shr    $0x18,%eax
80107f31:	c1 e9 10             	shr    $0x10,%ecx
80107f34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107f3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107f40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107f45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107f51:	e8 8a b9 ff ff       	call   801038e0 <mycpu>
80107f56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f5d:	e8 7e b9 ff ff       	call   801038e0 <mycpu>
80107f62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107f66:	8b 5e 08             	mov    0x8(%esi),%ebx
80107f69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f6f:	e8 6c b9 ff ff       	call   801038e0 <mycpu>
80107f74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f77:	e8 64 b9 ff ff       	call   801038e0 <mycpu>
80107f7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107f80:	b8 28 00 00 00       	mov    $0x28,%eax
80107f85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107f88:	8b 46 04             	mov    0x4(%esi),%eax
80107f8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f90:	0f 22 d8             	mov    %eax,%cr3
}
80107f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f96:	5b                   	pop    %ebx
80107f97:	5e                   	pop    %esi
80107f98:	5f                   	pop    %edi
80107f99:	5d                   	pop    %ebp
  popcli();
80107f9a:	e9 51 c8 ff ff       	jmp    801047f0 <popcli>
    panic("switchuvm: no process");
80107f9f:	83 ec 0c             	sub    $0xc,%esp
80107fa2:	68 ab 8a 10 80       	push   $0x80108aab
80107fa7:	e8 d4 83 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107fac:	83 ec 0c             	sub    $0xc,%esp
80107faf:	68 d6 8a 10 80       	push   $0x80108ad6
80107fb4:	e8 c7 83 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107fb9:	83 ec 0c             	sub    $0xc,%esp
80107fbc:	68 c1 8a 10 80       	push   $0x80108ac1
80107fc1:	e8 ba 83 ff ff       	call   80100380 <panic>
80107fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fcd:	8d 76 00             	lea    0x0(%esi),%esi

80107fd0 <inituvm>:
{
80107fd0:	55                   	push   %ebp
80107fd1:	89 e5                	mov    %esp,%ebp
80107fd3:	57                   	push   %edi
80107fd4:	56                   	push   %esi
80107fd5:	53                   	push   %ebx
80107fd6:	83 ec 1c             	sub    $0x1c,%esp
80107fd9:	8b 75 10             	mov    0x10(%ebp),%esi
80107fdc:	8b 55 08             	mov    0x8(%ebp),%edx
80107fdf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107fe2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107fe8:	77 50                	ja     8010803a <inituvm+0x6a>
80107fea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80107fed:	e8 6e a6 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80107ff2:	83 ec 04             	sub    $0x4,%esp
80107ff5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107ffa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107ffc:	6a 00                	push   $0x0
80107ffe:	50                   	push   %eax
80107fff:	e8 ec c9 ff ff       	call   801049f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108004:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010800a:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80108011:	50                   	push   %eax
80108012:	68 00 10 00 00       	push   $0x1000
80108017:	6a 00                	push   $0x0
80108019:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010801c:	52                   	push   %edx
8010801d:	e8 9e fd ff ff       	call   80107dc0 <mappages>
  memmove(mem, init, sz);
80108022:	89 75 10             	mov    %esi,0x10(%ebp)
80108025:	83 c4 20             	add    $0x20,%esp
80108028:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010802b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010802e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108031:	5b                   	pop    %ebx
80108032:	5e                   	pop    %esi
80108033:	5f                   	pop    %edi
80108034:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108035:	e9 46 ca ff ff       	jmp    80104a80 <memmove>
    panic("inituvm: more than a page");
8010803a:	83 ec 0c             	sub    $0xc,%esp
8010803d:	68 ea 8a 10 80       	push   $0x80108aea
80108042:	e8 39 83 ff ff       	call   80100380 <panic>
80108047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010804e:	66 90                	xchg   %ax,%ax

80108050 <loaduvm>:
{
80108050:	55                   	push   %ebp
80108051:	89 e5                	mov    %esp,%ebp
80108053:	57                   	push   %edi
80108054:	56                   	push   %esi
80108055:	53                   	push   %ebx
80108056:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108059:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010805c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010805f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80108065:	0f 85 a2 00 00 00    	jne    8010810d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010806b:	85 ff                	test   %edi,%edi
8010806d:	74 7d                	je     801080ec <loaduvm+0x9c>
8010806f:	90                   	nop
  pde = &pgdir[PDX(va)];
80108070:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108073:	8b 55 08             	mov    0x8(%ebp),%edx
80108076:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80108078:	89 c1                	mov    %eax,%ecx
8010807a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010807d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80108080:	f6 c1 01             	test   $0x1,%cl
80108083:	75 13                	jne    80108098 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80108085:	83 ec 0c             	sub    $0xc,%esp
80108088:	68 04 8b 10 80       	push   $0x80108b04
8010808d:	e8 ee 82 ff ff       	call   80100380 <panic>
80108092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108098:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010809b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801080a1:	25 fc 0f 00 00       	and    $0xffc,%eax
801080a6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801080ad:	85 c9                	test   %ecx,%ecx
801080af:	74 d4                	je     80108085 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801080b1:	89 fb                	mov    %edi,%ebx
801080b3:	b8 00 10 00 00       	mov    $0x1000,%eax
801080b8:	29 f3                	sub    %esi,%ebx
801080ba:	39 c3                	cmp    %eax,%ebx
801080bc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801080bf:	53                   	push   %ebx
801080c0:	8b 45 14             	mov    0x14(%ebp),%eax
801080c3:	01 f0                	add    %esi,%eax
801080c5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801080c6:	8b 01                	mov    (%ecx),%eax
801080c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801080cd:	05 00 00 00 80       	add    $0x80000000,%eax
801080d2:	50                   	push   %eax
801080d3:	ff 75 10             	push   0x10(%ebp)
801080d6:	e8 d5 99 ff ff       	call   80101ab0 <readi>
801080db:	83 c4 10             	add    $0x10,%esp
801080de:	39 d8                	cmp    %ebx,%eax
801080e0:	75 1e                	jne    80108100 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801080e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801080e8:	39 fe                	cmp    %edi,%esi
801080ea:	72 84                	jb     80108070 <loaduvm+0x20>
}
801080ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080ef:	31 c0                	xor    %eax,%eax
}
801080f1:	5b                   	pop    %ebx
801080f2:	5e                   	pop    %esi
801080f3:	5f                   	pop    %edi
801080f4:	5d                   	pop    %ebp
801080f5:	c3                   	ret
801080f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080fd:	8d 76 00             	lea    0x0(%esi),%esi
80108100:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108108:	5b                   	pop    %ebx
80108109:	5e                   	pop    %esi
8010810a:	5f                   	pop    %edi
8010810b:	5d                   	pop    %ebp
8010810c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010810d:	83 ec 0c             	sub    $0xc,%esp
80108110:	68 94 8d 10 80       	push   $0x80108d94
80108115:	e8 66 82 ff ff       	call   80100380 <panic>
8010811a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108120 <allocuvm>:
{
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
80108123:	57                   	push   %edi
80108124:	56                   	push   %esi
80108125:	53                   	push   %ebx
80108126:	83 ec 1c             	sub    $0x1c,%esp
80108129:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010812c:	85 f6                	test   %esi,%esi
8010812e:	0f 88 9a 00 00 00    	js     801081ce <allocuvm+0xae>
80108134:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80108136:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108139:	0f 82 a1 00 00 00    	jb     801081e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010813f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108142:	05 ff 0f 00 00       	add    $0xfff,%eax
80108147:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010814c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010814e:	39 f0                	cmp    %esi,%eax
80108150:	0f 83 8d 00 00 00    	jae    801081e3 <allocuvm+0xc3>
80108156:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80108159:	eb 46                	jmp    801081a1 <allocuvm+0x81>
8010815b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010815f:	90                   	nop
    memset(mem, 0, PGSIZE);
80108160:	83 ec 04             	sub    $0x4,%esp
80108163:	68 00 10 00 00       	push   $0x1000
80108168:	6a 00                	push   $0x0
8010816a:	50                   	push   %eax
8010816b:	e8 80 c8 ff ff       	call   801049f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108170:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108176:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010817d:	50                   	push   %eax
8010817e:	68 00 10 00 00       	push   $0x1000
80108183:	57                   	push   %edi
80108184:	ff 75 08             	push   0x8(%ebp)
80108187:	e8 34 fc ff ff       	call   80107dc0 <mappages>
8010818c:	83 c4 20             	add    $0x20,%esp
8010818f:	85 c0                	test   %eax,%eax
80108191:	78 5d                	js     801081f0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80108193:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108199:	39 f7                	cmp    %esi,%edi
8010819b:	0f 83 87 00 00 00    	jae    80108228 <allocuvm+0x108>
    mem = kalloc();
801081a1:	e8 ba a4 ff ff       	call   80102660 <kalloc>
801081a6:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801081a8:	85 c0                	test   %eax,%eax
801081aa:	75 b4                	jne    80108160 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801081ac:	83 ec 0c             	sub    $0xc,%esp
801081af:	68 22 8b 10 80       	push   $0x80108b22
801081b4:	e8 f7 84 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801081b9:	83 c4 10             	add    $0x10,%esp
801081bc:	3b 75 0c             	cmp    0xc(%ebp),%esi
801081bf:	74 0d                	je     801081ce <allocuvm+0xae>
801081c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801081c4:	8b 45 08             	mov    0x8(%ebp),%eax
801081c7:	89 f2                	mov    %esi,%edx
801081c9:	e8 12 fa ff ff       	call   80107be0 <deallocuvm.part.0>
    return 0;
801081ce:	31 d2                	xor    %edx,%edx
}
801081d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081d3:	89 d0                	mov    %edx,%eax
801081d5:	5b                   	pop    %ebx
801081d6:	5e                   	pop    %esi
801081d7:	5f                   	pop    %edi
801081d8:	5d                   	pop    %ebp
801081d9:	c3                   	ret
801081da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
801081e0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801081e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081e6:	89 d0                	mov    %edx,%eax
801081e8:	5b                   	pop    %ebx
801081e9:	5e                   	pop    %esi
801081ea:	5f                   	pop    %edi
801081eb:	5d                   	pop    %ebp
801081ec:	c3                   	ret
801081ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801081f0:	83 ec 0c             	sub    $0xc,%esp
801081f3:	68 3a 8b 10 80       	push   $0x80108b3a
801081f8:	e8 b3 84 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801081fd:	83 c4 10             	add    $0x10,%esp
80108200:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108203:	74 0d                	je     80108212 <allocuvm+0xf2>
80108205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108208:	8b 45 08             	mov    0x8(%ebp),%eax
8010820b:	89 f2                	mov    %esi,%edx
8010820d:	e8 ce f9 ff ff       	call   80107be0 <deallocuvm.part.0>
      kfree(mem);
80108212:	83 ec 0c             	sub    $0xc,%esp
80108215:	53                   	push   %ebx
80108216:	e8 85 a2 ff ff       	call   801024a0 <kfree>
      return 0;
8010821b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010821e:	31 d2                	xor    %edx,%edx
80108220:	eb ae                	jmp    801081d0 <allocuvm+0xb0>
80108222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010822b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010822e:	5b                   	pop    %ebx
8010822f:	5e                   	pop    %esi
80108230:	89 d0                	mov    %edx,%eax
80108232:	5f                   	pop    %edi
80108233:	5d                   	pop    %ebp
80108234:	c3                   	ret
80108235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010823c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108240 <deallocuvm>:
{
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	8b 55 0c             	mov    0xc(%ebp),%edx
80108246:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108249:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010824c:	39 d1                	cmp    %edx,%ecx
8010824e:	73 10                	jae    80108260 <deallocuvm+0x20>
}
80108250:	5d                   	pop    %ebp
80108251:	e9 8a f9 ff ff       	jmp    80107be0 <deallocuvm.part.0>
80108256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010825d:	8d 76 00             	lea    0x0(%esi),%esi
80108260:	89 d0                	mov    %edx,%eax
80108262:	5d                   	pop    %ebp
80108263:	c3                   	ret
80108264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010826b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010826f:	90                   	nop

80108270 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108270:	55                   	push   %ebp
80108271:	89 e5                	mov    %esp,%ebp
80108273:	57                   	push   %edi
80108274:	56                   	push   %esi
80108275:	53                   	push   %ebx
80108276:	83 ec 0c             	sub    $0xc,%esp
80108279:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010827c:	85 f6                	test   %esi,%esi
8010827e:	74 59                	je     801082d9 <freevm+0x69>
  if(newsz >= oldsz)
80108280:	31 c9                	xor    %ecx,%ecx
80108282:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108287:	89 f0                	mov    %esi,%eax
80108289:	89 f3                	mov    %esi,%ebx
8010828b:	e8 50 f9 ff ff       	call   80107be0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108290:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108296:	eb 0f                	jmp    801082a7 <freevm+0x37>
80108298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010829f:	90                   	nop
801082a0:	83 c3 04             	add    $0x4,%ebx
801082a3:	39 fb                	cmp    %edi,%ebx
801082a5:	74 23                	je     801082ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801082a7:	8b 03                	mov    (%ebx),%eax
801082a9:	a8 01                	test   $0x1,%al
801082ab:	74 f3                	je     801082a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801082ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801082b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801082b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801082bd:	50                   	push   %eax
801082be:	e8 dd a1 ff ff       	call   801024a0 <kfree>
801082c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082c6:	39 fb                	cmp    %edi,%ebx
801082c8:	75 dd                	jne    801082a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801082ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801082cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082d0:	5b                   	pop    %ebx
801082d1:	5e                   	pop    %esi
801082d2:	5f                   	pop    %edi
801082d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801082d4:	e9 c7 a1 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
801082d9:	83 ec 0c             	sub    $0xc,%esp
801082dc:	68 56 8b 10 80       	push   $0x80108b56
801082e1:	e8 9a 80 ff ff       	call   80100380 <panic>
801082e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082ed:	8d 76 00             	lea    0x0(%esi),%esi

801082f0 <setupkvm>:
{
801082f0:	55                   	push   %ebp
801082f1:	89 e5                	mov    %esp,%ebp
801082f3:	56                   	push   %esi
801082f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801082f5:	e8 66 a3 ff ff       	call   80102660 <kalloc>
801082fa:	85 c0                	test   %eax,%eax
801082fc:	74 5e                	je     8010835c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801082fe:	83 ec 04             	sub    $0x4,%esp
80108301:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108303:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108308:	68 00 10 00 00       	push   $0x1000
8010830d:	6a 00                	push   $0x0
8010830f:	50                   	push   %eax
80108310:	e8 db c6 ff ff       	call   801049f0 <memset>
80108315:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108318:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010831b:	83 ec 0c             	sub    $0xc,%esp
8010831e:	ff 73 0c             	push   0xc(%ebx)
80108321:	52                   	push   %edx
80108322:	8b 43 08             	mov    0x8(%ebx),%eax
80108325:	29 d0                	sub    %edx,%eax
80108327:	50                   	push   %eax
80108328:	ff 33                	push   (%ebx)
8010832a:	56                   	push   %esi
8010832b:	e8 90 fa ff ff       	call   80107dc0 <mappages>
80108330:	83 c4 20             	add    $0x20,%esp
80108333:	85 c0                	test   %eax,%eax
80108335:	78 19                	js     80108350 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108337:	83 c3 10             	add    $0x10,%ebx
8010833a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108340:	75 d6                	jne    80108318 <setupkvm+0x28>
}
80108342:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108345:	89 f0                	mov    %esi,%eax
80108347:	5b                   	pop    %ebx
80108348:	5e                   	pop    %esi
80108349:	5d                   	pop    %ebp
8010834a:	c3                   	ret
8010834b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010834f:	90                   	nop
      freevm(pgdir);
80108350:	83 ec 0c             	sub    $0xc,%esp
80108353:	56                   	push   %esi
80108354:	e8 17 ff ff ff       	call   80108270 <freevm>
      return 0;
80108359:	83 c4 10             	add    $0x10,%esp
}
8010835c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010835f:	31 f6                	xor    %esi,%esi
}
80108361:	89 f0                	mov    %esi,%eax
80108363:	5b                   	pop    %ebx
80108364:	5e                   	pop    %esi
80108365:	5d                   	pop    %ebp
80108366:	c3                   	ret
80108367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010836e:	66 90                	xchg   %ax,%ax

80108370 <kvmalloc>:
{
80108370:	55                   	push   %ebp
80108371:	89 e5                	mov    %esp,%ebp
80108373:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108376:	e8 75 ff ff ff       	call   801082f0 <setupkvm>
8010837b:	a3 c4 04 15 80       	mov    %eax,0x801504c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108380:	05 00 00 00 80       	add    $0x80000000,%eax
80108385:	0f 22 d8             	mov    %eax,%cr3
}
80108388:	c9                   	leave
80108389:	c3                   	ret
8010838a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108390 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	83 ec 08             	sub    $0x8,%esp
80108396:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108399:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010839c:	89 c1                	mov    %eax,%ecx
8010839e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801083a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801083a4:	f6 c2 01             	test   $0x1,%dl
801083a7:	75 17                	jne    801083c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801083a9:	83 ec 0c             	sub    $0xc,%esp
801083ac:	68 67 8b 10 80       	push   $0x80108b67
801083b1:	e8 ca 7f ff ff       	call   80100380 <panic>
801083b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801083c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801083c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801083c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801083ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801083d5:	85 c0                	test   %eax,%eax
801083d7:	74 d0                	je     801083a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801083d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801083dc:	c9                   	leave
801083dd:	c3                   	ret
801083de:	66 90                	xchg   %ax,%ax

801083e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801083e0:	55                   	push   %ebp
801083e1:	89 e5                	mov    %esp,%ebp
801083e3:	57                   	push   %edi
801083e4:	56                   	push   %esi
801083e5:	53                   	push   %ebx
801083e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801083e9:	e8 02 ff ff ff       	call   801082f0 <setupkvm>
801083ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083f1:	85 c0                	test   %eax,%eax
801083f3:	0f 84 e9 00 00 00    	je     801084e2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801083f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801083fc:	85 d2                	test   %edx,%edx
801083fe:	0f 84 b5 00 00 00    	je     801084b9 <copyuvm+0xd9>
80108404:	31 f6                	xor    %esi,%esi
80108406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010840d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108413:	89 f0                	mov    %esi,%eax
80108415:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108418:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010841b:	a8 01                	test   $0x1,%al
8010841d:	75 11                	jne    80108430 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010841f:	83 ec 0c             	sub    $0xc,%esp
80108422:	68 71 8b 10 80       	push   $0x80108b71
80108427:	e8 54 7f ff ff       	call   80100380 <panic>
8010842c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108430:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108432:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108437:	c1 ea 0a             	shr    $0xa,%edx
8010843a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108440:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108447:	85 c0                	test   %eax,%eax
80108449:	74 d4                	je     8010841f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010844b:	8b 38                	mov    (%eax),%edi
8010844d:	f7 c7 01 00 00 00    	test   $0x1,%edi
80108453:	0f 84 9b 00 00 00    	je     801084f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108459:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
8010845b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80108461:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108464:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
8010846a:	e8 f1 a1 ff ff       	call   80102660 <kalloc>
8010846f:	89 c7                	mov    %eax,%edi
80108471:	85 c0                	test   %eax,%eax
80108473:	74 5f                	je     801084d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108475:	83 ec 04             	sub    $0x4,%esp
80108478:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010847e:	68 00 10 00 00       	push   $0x1000
80108483:	53                   	push   %ebx
80108484:	50                   	push   %eax
80108485:	e8 f6 c5 ff ff       	call   80104a80 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010848a:	58                   	pop    %eax
8010848b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80108491:	ff 75 e4             	push   -0x1c(%ebp)
80108494:	50                   	push   %eax
80108495:	68 00 10 00 00       	push   $0x1000
8010849a:	56                   	push   %esi
8010849b:	ff 75 e0             	push   -0x20(%ebp)
8010849e:	e8 1d f9 ff ff       	call   80107dc0 <mappages>
801084a3:	83 c4 20             	add    $0x20,%esp
801084a6:	85 c0                	test   %eax,%eax
801084a8:	78 1e                	js     801084c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801084aa:	81 c6 00 10 00 00    	add    $0x1000,%esi
801084b0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801084b3:	0f 82 57 ff ff ff    	jb     80108410 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801084b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084bf:	5b                   	pop    %ebx
801084c0:	5e                   	pop    %esi
801084c1:	5f                   	pop    %edi
801084c2:	5d                   	pop    %ebp
801084c3:	c3                   	ret
801084c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801084c8:	83 ec 0c             	sub    $0xc,%esp
801084cb:	57                   	push   %edi
801084cc:	e8 cf 9f ff ff       	call   801024a0 <kfree>
      goto bad;
801084d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801084d4:	83 ec 0c             	sub    $0xc,%esp
801084d7:	ff 75 e0             	push   -0x20(%ebp)
801084da:	e8 91 fd ff ff       	call   80108270 <freevm>
  return 0;
801084df:	83 c4 10             	add    $0x10,%esp
    return 0;
801084e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801084e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084ef:	5b                   	pop    %ebx
801084f0:	5e                   	pop    %esi
801084f1:	5f                   	pop    %edi
801084f2:	5d                   	pop    %ebp
801084f3:	c3                   	ret
      panic("copyuvm: page not present");
801084f4:	83 ec 0c             	sub    $0xc,%esp
801084f7:	68 8b 8b 10 80       	push   $0x80108b8b
801084fc:	e8 7f 7e ff ff       	call   80100380 <panic>
80108501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010850f:	90                   	nop

80108510 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108510:	55                   	push   %ebp
80108511:	89 e5                	mov    %esp,%ebp
80108513:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108516:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108519:	89 c1                	mov    %eax,%ecx
8010851b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010851e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108521:	f6 c2 01             	test   $0x1,%dl
80108524:	0f 84 f8 00 00 00    	je     80108622 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010852a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010852d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108533:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108534:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108539:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108540:	89 d0                	mov    %edx,%eax
80108542:	f7 d2                	not    %edx
80108544:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108549:	05 00 00 00 80       	add    $0x80000000,%eax
8010854e:	83 e2 05             	and    $0x5,%edx
80108551:	ba 00 00 00 00       	mov    $0x0,%edx
80108556:	0f 45 c2             	cmovne %edx,%eax
}
80108559:	c3                   	ret
8010855a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108560 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108560:	55                   	push   %ebp
80108561:	89 e5                	mov    %esp,%ebp
80108563:	57                   	push   %edi
80108564:	56                   	push   %esi
80108565:	53                   	push   %ebx
80108566:	83 ec 0c             	sub    $0xc,%esp
80108569:	8b 75 14             	mov    0x14(%ebp),%esi
8010856c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010856f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108572:	85 f6                	test   %esi,%esi
80108574:	75 51                	jne    801085c7 <copyout+0x67>
80108576:	e9 9d 00 00 00       	jmp    80108618 <copyout+0xb8>
8010857b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010857f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108580:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108586:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010858c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108592:	74 74                	je     80108608 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80108594:	89 fb                	mov    %edi,%ebx
80108596:	29 c3                	sub    %eax,%ebx
80108598:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010859e:	39 f3                	cmp    %esi,%ebx
801085a0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801085a3:	29 f8                	sub    %edi,%eax
801085a5:	83 ec 04             	sub    $0x4,%esp
801085a8:	01 c1                	add    %eax,%ecx
801085aa:	53                   	push   %ebx
801085ab:	52                   	push   %edx
801085ac:	89 55 10             	mov    %edx,0x10(%ebp)
801085af:	51                   	push   %ecx
801085b0:	e8 cb c4 ff ff       	call   80104a80 <memmove>
    len -= n;
    buf += n;
801085b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801085b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801085be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801085c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801085c3:	29 de                	sub    %ebx,%esi
801085c5:	74 51                	je     80108618 <copyout+0xb8>
  if(*pde & PTE_P){
801085c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801085ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801085cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801085ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801085d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801085d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801085da:	f6 c1 01             	test   $0x1,%cl
801085dd:	0f 84 46 00 00 00    	je     80108629 <copyout.cold>
  return &pgtab[PTX(va)];
801085e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801085e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801085eb:	c1 eb 0c             	shr    $0xc,%ebx
801085ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801085f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801085fb:	89 d9                	mov    %ebx,%ecx
801085fd:	f7 d1                	not    %ecx
801085ff:	83 e1 05             	and    $0x5,%ecx
80108602:	0f 84 78 ff ff ff    	je     80108580 <copyout+0x20>
  }
  return 0;
}
80108608:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010860b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108610:	5b                   	pop    %ebx
80108611:	5e                   	pop    %esi
80108612:	5f                   	pop    %edi
80108613:	5d                   	pop    %ebp
80108614:	c3                   	ret
80108615:	8d 76 00             	lea    0x0(%esi),%esi
80108618:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010861b:	31 c0                	xor    %eax,%eax
}
8010861d:	5b                   	pop    %ebx
8010861e:	5e                   	pop    %esi
8010861f:	5f                   	pop    %edi
80108620:	5d                   	pop    %ebp
80108621:	c3                   	ret

80108622 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108622:	a1 00 00 00 00       	mov    0x0,%eax
80108627:	0f 0b                	ud2

80108629 <copyout.cold>:
80108629:	a1 00 00 00 00       	mov    0x0,%eax
8010862e:	0f 0b                	ud2
