
_wremap:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "wmap.h"

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    // addr1 = wmap(0x6000a000, length1*10, flags, fd);
    // if (addr1 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    addr2 = wmap(0x60002000, length1*5, flags, fd);
  11:	6a ff                	push   $0xffffffff
  13:	6a 0c                	push   $0xc
  15:	68 00 50 00 00       	push   $0x5000
  1a:	68 00 20 00 60       	push   $0x60002000
  1f:	e8 6f 03 00 00       	call   393 <wmap>
    if (addr2 == (uint)-1) {
  24:	83 c4 10             	add    $0x10,%esp
    addr2 = wmap(0x60002000, length1*5, flags, fd);
  27:	89 c2                	mov    %eax,%edx
    if (addr2 == (uint)-1) {
  29:	b8 00 00 00 60       	mov    $0x60000000,%eax
  2e:	83 fa ff             	cmp    $0xffffffff,%edx
  31:	74 5d                	je     90 <main+0x90>
  33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  37:	90                   	nop
    int flag = MREMAP_MAYMOVE;

    char *arr = (char *)addr;
    int value = 'y';
    for (int i = 0; i < length1 * 3; i++)
        arr[i] = value;
  38:	c6 00 79             	movb   $0x79,(%eax)
    for (int i = 0; i < length1 * 3; i++)
  3b:	83 c0 02             	add    $0x2,%eax
        arr[i] = value;
  3e:	c6 40 ff 79          	movb   $0x79,-0x1(%eax)
    for (int i = 0; i < length1 * 3; i++)
  42:	3d 00 30 00 60       	cmp    $0x60003000,%eax
  47:	75 ef                	jne    38 <main+0x38>

    uint newaddr = wremap(addr, oldsize, newsize, flag);
  49:	6a 01                	push   $0x1
  4b:	68 00 10 00 00       	push   $0x1000
  50:	68 00 50 00 00       	push   $0x5000
  55:	68 00 00 00 60       	push   $0x60000000
  5a:	e8 44 03 00 00       	call   3a3 <wremap>
    if (newaddr == (uint) -1) {
  5f:	83 c4 10             	add    $0x10,%esp
  62:	83 f8 ff             	cmp    $0xffffffff,%eax
  65:	74 16                	je     7d <main+0x7d>
        printf(1, "wremap failed\n");
    } else {
        printf(1, "wremap succeeded, new address: 0x%x\n", newaddr);
  67:	52                   	push   %edx
  68:	50                   	push   %eax
  69:	68 8c 07 00 00       	push   $0x78c
  6e:	6a 01                	push   $0x1
  70:	e8 eb 03 00 00       	call   460 <printf>
  75:	83 c4 10             	add    $0x10,%esp
    // for (int i = 0; i < wminfo.total_mmaps; i++) {
    //     printf(1, "Mapping %d: Addr 0x%x, Length %d, Loaded Pages %d\n",
    //            i, wminfo.addr[i], wminfo.length[i], wminfo.n_loaded_pages[i]);
    // }

    exit();
  78:	e8 76 02 00 00       	call   2f3 <exit>
        printf(1, "wremap failed\n");
  7d:	51                   	push   %ecx
  7e:	51                   	push   %ecx
  7f:	68 75 07 00 00       	push   $0x775
  84:	6a 01                	push   $0x1
  86:	e8 d5 03 00 00       	call   460 <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	eb e8                	jmp    78 <main+0x78>
        printf(1, "wmap failed\n");
  90:	50                   	push   %eax
  91:	50                   	push   %eax
  92:	68 68 07 00 00       	push   $0x768
  97:	6a 01                	push   $0x1
  99:	e8 c2 03 00 00       	call   460 <printf>
        exit();
  9e:	e8 50 02 00 00       	call   2f3 <exit>
  a3:	66 90                	xchg   %ax,%ax
  a5:	66 90                	xchg   %ax,%ax
  a7:	66 90                	xchg   %ax,%ax
  a9:	66 90                	xchg   %ax,%ax
  ab:	66 90                	xchg   %ax,%ax
  ad:	66 90                	xchg   %ax,%ax
  af:	90                   	nop

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b1:	31 c0                	xor    %eax,%eax
{
  b3:	89 e5                	mov    %esp,%ebp
  b5:	53                   	push   %ebx
  b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	84 d2                	test   %dl,%dl
  cc:	75 f2                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d1:	89 c8                	mov    %ecx,%eax
  d3:	c9                   	leave
  d4:	c3                   	ret
  d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	84 c0                	test   %al,%al
  ef:	75 17                	jne    108 <strcmp+0x28>
  f1:	eb 3a                	jmp    12d <strcmp+0x4d>
  f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f7:	90                   	nop
  f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  fc:	83 c2 01             	add    $0x1,%edx
  ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 102:	84 c0                	test   %al,%al
 104:	74 1a                	je     120 <strcmp+0x40>
 106:	89 d9                	mov    %ebx,%ecx
 108:	0f b6 19             	movzbl (%ecx),%ebx
 10b:	38 c3                	cmp    %al,%bl
 10d:	74 e9                	je     f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 10f:	29 d8                	sub    %ebx,%eax
}
 111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 114:	c9                   	leave
 115:	c3                   	ret
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 120:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 124:	31 c0                	xor    %eax,%eax
 126:	29 d8                	sub    %ebx,%eax
}
 128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 12b:	c9                   	leave
 12c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	31 c0                	xor    %eax,%eax
 132:	eb db                	jmp    10f <strcmp+0x2f>
 134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop

00000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 3a 00             	cmpb   $0x0,(%edx)
 149:	74 15                	je     160 <strlen+0x20>
 14b:	31 c0                	xor    %eax,%eax
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c0 01             	add    $0x1,%eax
 153:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 157:	89 c1                	mov    %eax,%ecx
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	89 c8                	mov    %ecx,%eax
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret
 15f:	90                   	nop
  for(n = 0; s[n]; n++)
 160:	31 c9                	xor    %ecx,%ecx
}
 162:	5d                   	pop    %ebp
 163:	89 c8                	mov    %ecx,%eax
 165:	c3                   	ret
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	8b 7d fc             	mov    -0x4(%ebp),%edi
 185:	89 d0                	mov    %edx,%eax
 187:	c9                   	leave
 188:	c3                   	ret
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19a:	0f b6 10             	movzbl (%eax),%edx
 19d:	84 d2                	test   %dl,%dl
 19f:	75 12                	jne    1b3 <strchr+0x23>
 1a1:	eb 1d                	jmp    1c0 <strchr+0x30>
 1a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a7:	90                   	nop
 1a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1ac:	83 c0 01             	add    $0x1,%eax
 1af:	84 d2                	test   %dl,%dl
 1b1:	74 0d                	je     1c0 <strchr+0x30>
    if(*s == c)
 1b3:	38 d1                	cmp    %dl,%cl
 1b5:	75 f1                	jne    1a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1c0:	31 c0                	xor    %eax,%eax
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret
 1c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1cf:	90                   	nop

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1d5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 1d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1d9:	31 db                	xor    %ebx,%ebx
{
 1db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1de:	eb 27                	jmp    207 <gets+0x37>
    cc = read(0, &c, 1);
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	6a 01                	push   $0x1
 1e5:	56                   	push   %esi
 1e6:	6a 00                	push   $0x0
 1e8:	e8 1e 01 00 00       	call   30b <read>
    if(cc < 1)
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	85 c0                	test   %eax,%eax
 1f2:	7e 1d                	jle    211 <gets+0x41>
      break;
    buf[i++] = c;
 1f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
 1fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ff:	3c 0a                	cmp    $0xa,%al
 201:	74 10                	je     213 <gets+0x43>
 203:	3c 0d                	cmp    $0xd,%al
 205:	74 0c                	je     213 <gets+0x43>
  for(i=0; i+1 < max; ){
 207:	89 df                	mov    %ebx,%edi
 209:	83 c3 01             	add    $0x1,%ebx
 20c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 20f:	7c cf                	jl     1e0 <gets+0x10>
 211:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 21a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21d:	5b                   	pop    %ebx
 21e:	5e                   	pop    %esi
 21f:	5f                   	pop    %edi
 220:	5d                   	pop    %ebp
 221:	c3                   	ret
 222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	push   0x8(%ebp)
 23d:	e8 f1 00 00 00       	call   333 <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	push   0xc(%ebp)
 24f:	89 c3                	mov    %eax,%ebx
 251:	50                   	push   %eax
 252:	e8 f4 00 00 00       	call   34b <fstat>
  close(fd);
 257:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25a:	89 c6                	mov    %eax,%esi
  close(fd);
 25c:	e8 ba 00 00 00       	call   31b <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	8d 65 f8             	lea    -0x8(%ebp),%esp
 267:	89 f0                	mov    %esi,%eax
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 02             	movsbl (%edx),%eax
 28a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 28d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 290:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 295:	77 1e                	ja     2b5 <atoi+0x35>
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2aa:	0f be 02             	movsbl (%edx),%eax
 2ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b8:	89 c8                	mov    %ecx,%eax
 2ba:	c9                   	leave
 2bb:	c3                   	ret
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 45 10             	mov    0x10(%ebp),%eax
 2c7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ca:	56                   	push   %esi
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 c0                	test   %eax,%eax
 2d0:	7e 13                	jle    2e5 <memmove+0x25>
 2d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d4:	89 d7                	mov    %edx,%edi
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 f8                	cmp    %edi,%eax
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <wmap>:
SYSCALL(wmap)
 393:	b8 16 00 00 00       	mov    $0x16,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <wunmap>:
SYSCALL(wunmap)
 39b:	b8 17 00 00 00       	mov    $0x17,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <wremap>:
SYSCALL(wremap)
 3a3:	b8 18 00 00 00       	mov    $0x18,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <getwmapinfo>:
SYSCALL(getwmapinfo)
 3ab:	b8 19 00 00 00       	mov    $0x19,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 3b3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret
 3bb:	66 90                	xchg   %ax,%ax
 3bd:	66 90                	xchg   %ax,%ax
 3bf:	90                   	nop

000003c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3c8:	89 d1                	mov    %edx,%ecx
{
 3ca:	83 ec 3c             	sub    $0x3c,%esp
 3cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3d0:	85 d2                	test   %edx,%edx
 3d2:	0f 89 80 00 00 00    	jns    458 <printint+0x98>
 3d8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3dc:	74 7a                	je     458 <printint+0x98>
    x = -xx;
 3de:	f7 d9                	neg    %ecx
    neg = 1;
 3e0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3e8:	31 f6                	xor    %esi,%esi
 3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3f0:	89 c8                	mov    %ecx,%eax
 3f2:	31 d2                	xor    %edx,%edx
 3f4:	89 f7                	mov    %esi,%edi
 3f6:	f7 f3                	div    %ebx
 3f8:	8d 76 01             	lea    0x1(%esi),%esi
 3fb:	0f b6 92 0c 08 00 00 	movzbl 0x80c(%edx),%edx
 402:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 406:	89 ca                	mov    %ecx,%edx
 408:	89 c1                	mov    %eax,%ecx
 40a:	39 da                	cmp    %ebx,%edx
 40c:	73 e2                	jae    3f0 <printint+0x30>
  if(neg)
 40e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 411:	85 c0                	test   %eax,%eax
 413:	74 07                	je     41c <printint+0x5c>
    buf[i++] = '-';
 415:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 41a:	89 f7                	mov    %esi,%edi
 41c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 41f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 422:	01 df                	add    %ebx,%edi
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 428:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 42b:	83 ec 04             	sub    $0x4,%esp
 42e:	88 45 d7             	mov    %al,-0x29(%ebp)
 431:	8d 45 d7             	lea    -0x29(%ebp),%eax
 434:	6a 01                	push   $0x1
 436:	50                   	push   %eax
 437:	56                   	push   %esi
 438:	e8 d6 fe ff ff       	call   313 <write>
  while(--i >= 0)
 43d:	89 f8                	mov    %edi,%eax
 43f:	83 c4 10             	add    $0x10,%esp
 442:	83 ef 01             	sub    $0x1,%edi
 445:	39 c3                	cmp    %eax,%ebx
 447:	75 df                	jne    428 <printint+0x68>
}
 449:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44c:	5b                   	pop    %ebx
 44d:	5e                   	pop    %esi
 44e:	5f                   	pop    %edi
 44f:	5d                   	pop    %ebp
 450:	c3                   	ret
 451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 458:	31 c0                	xor    %eax,%eax
 45a:	eb 89                	jmp    3e5 <printint+0x25>
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000460 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 469:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 46c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 46f:	0f b6 1e             	movzbl (%esi),%ebx
 472:	83 c6 01             	add    $0x1,%esi
 475:	84 db                	test   %bl,%bl
 477:	74 67                	je     4e0 <printf+0x80>
 479:	8d 4d 10             	lea    0x10(%ebp),%ecx
 47c:	31 d2                	xor    %edx,%edx
 47e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 481:	eb 34                	jmp    4b7 <printf+0x57>
 483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 487:	90                   	nop
 488:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 48b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 490:	83 f8 25             	cmp    $0x25,%eax
 493:	74 18                	je     4ad <printf+0x4d>
  write(fd, &c, 1);
 495:	83 ec 04             	sub    $0x4,%esp
 498:	8d 45 e7             	lea    -0x19(%ebp),%eax
 49b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 49e:	6a 01                	push   $0x1
 4a0:	50                   	push   %eax
 4a1:	57                   	push   %edi
 4a2:	e8 6c fe ff ff       	call   313 <write>
 4a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4aa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4ad:	0f b6 1e             	movzbl (%esi),%ebx
 4b0:	83 c6 01             	add    $0x1,%esi
 4b3:	84 db                	test   %bl,%bl
 4b5:	74 29                	je     4e0 <printf+0x80>
    c = fmt[i] & 0xff;
 4b7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4ba:	85 d2                	test   %edx,%edx
 4bc:	74 ca                	je     488 <printf+0x28>
      }
    } else if(state == '%'){
 4be:	83 fa 25             	cmp    $0x25,%edx
 4c1:	75 ea                	jne    4ad <printf+0x4d>
      if(c == 'd'){
 4c3:	83 f8 25             	cmp    $0x25,%eax
 4c6:	0f 84 04 01 00 00    	je     5d0 <printf+0x170>
 4cc:	83 e8 63             	sub    $0x63,%eax
 4cf:	83 f8 15             	cmp    $0x15,%eax
 4d2:	77 1c                	ja     4f0 <printf+0x90>
 4d4:	ff 24 85 b4 07 00 00 	jmp    *0x7b4(,%eax,4)
 4db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop
  write(fd, &c, 1);
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4f6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4fa:	6a 01                	push   $0x1
 4fc:	52                   	push   %edx
 4fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 500:	57                   	push   %edi
 501:	e8 0d fe ff ff       	call   313 <write>
 506:	83 c4 0c             	add    $0xc,%esp
 509:	88 5d e7             	mov    %bl,-0x19(%ebp)
 50c:	6a 01                	push   $0x1
 50e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 511:	52                   	push   %edx
 512:	57                   	push   %edi
 513:	e8 fb fd ff ff       	call   313 <write>
        putc(fd, c);
 518:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51b:	31 d2                	xor    %edx,%edx
 51d:	eb 8e                	jmp    4ad <printf+0x4d>
 51f:	90                   	nop
        printint(fd, *ap, 16, 0);
 520:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 523:	83 ec 0c             	sub    $0xc,%esp
 526:	b9 10 00 00 00       	mov    $0x10,%ecx
 52b:	8b 13                	mov    (%ebx),%edx
 52d:	6a 00                	push   $0x0
 52f:	89 f8                	mov    %edi,%eax
        ap++;
 531:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 534:	e8 87 fe ff ff       	call   3c0 <printint>
        ap++;
 539:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 53c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53f:	31 d2                	xor    %edx,%edx
 541:	e9 67 ff ff ff       	jmp    4ad <printf+0x4d>
        s = (char*)*ap;
 546:	8b 45 d0             	mov    -0x30(%ebp),%eax
 549:	8b 18                	mov    (%eax),%ebx
        ap++;
 54b:	83 c0 04             	add    $0x4,%eax
 54e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 551:	85 db                	test   %ebx,%ebx
 553:	0f 84 87 00 00 00    	je     5e0 <printf+0x180>
        while(*s != 0){
 559:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 55c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 55e:	84 c0                	test   %al,%al
 560:	0f 84 47 ff ff ff    	je     4ad <printf+0x4d>
 566:	8d 55 e7             	lea    -0x19(%ebp),%edx
 569:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 56c:	89 de                	mov    %ebx,%esi
 56e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 576:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 579:	6a 01                	push   $0x1
 57b:	53                   	push   %ebx
 57c:	57                   	push   %edi
 57d:	e8 91 fd ff ff       	call   313 <write>
        while(*s != 0){
 582:	0f b6 06             	movzbl (%esi),%eax
 585:	83 c4 10             	add    $0x10,%esp
 588:	84 c0                	test   %al,%al
 58a:	75 e4                	jne    570 <printf+0x110>
      state = 0;
 58c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 58f:	31 d2                	xor    %edx,%edx
 591:	e9 17 ff ff ff       	jmp    4ad <printf+0x4d>
        printint(fd, *ap, 10, 1);
 596:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 599:	83 ec 0c             	sub    $0xc,%esp
 59c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a1:	8b 13                	mov    (%ebx),%edx
 5a3:	6a 01                	push   $0x1
 5a5:	eb 88                	jmp    52f <printf+0xcf>
        putc(fd, *ap);
 5a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5aa:	83 ec 04             	sub    $0x4,%esp
 5ad:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 5b0:	8b 03                	mov    (%ebx),%eax
        ap++;
 5b2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 5b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b8:	6a 01                	push   $0x1
 5ba:	52                   	push   %edx
 5bb:	57                   	push   %edi
 5bc:	e8 52 fd ff ff       	call   313 <write>
        ap++;
 5c1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5c4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c7:	31 d2                	xor    %edx,%edx
 5c9:	e9 df fe ff ff       	jmp    4ad <printf+0x4d>
 5ce:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5d6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5d9:	6a 01                	push   $0x1
 5db:	e9 31 ff ff ff       	jmp    511 <printf+0xb1>
 5e0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5e5:	bb 84 07 00 00       	mov    $0x784,%ebx
 5ea:	e9 77 ff ff ff       	jmp    566 <printf+0x106>
 5ef:	90                   	nop

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	a1 20 08 00 00       	mov    0x820,%eax
{
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60a:	39 c8                	cmp    %ecx,%eax
 60c:	73 32                	jae    640 <free+0x50>
 60e:	39 d1                	cmp    %edx,%ecx
 610:	72 04                	jb     616 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 612:	39 d0                	cmp    %edx,%eax
 614:	72 32                	jb     648 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 616:	8b 73 fc             	mov    -0x4(%ebx),%esi
 619:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 61c:	39 fa                	cmp    %edi,%edx
 61e:	74 30                	je     650 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 620:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 623:	8b 50 04             	mov    0x4(%eax),%edx
 626:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 629:	39 f1                	cmp    %esi,%ecx
 62b:	74 3a                	je     667 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 62d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 62f:	5b                   	pop    %ebx
  freep = p;
 630:	a3 20 08 00 00       	mov    %eax,0x820
}
 635:	5e                   	pop    %esi
 636:	5f                   	pop    %edi
 637:	5d                   	pop    %ebp
 638:	c3                   	ret
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	39 d0                	cmp    %edx,%eax
 642:	72 04                	jb     648 <free+0x58>
 644:	39 d1                	cmp    %edx,%ecx
 646:	72 ce                	jb     616 <free+0x26>
{
 648:	89 d0                	mov    %edx,%eax
 64a:	eb bc                	jmp    608 <free+0x18>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 650:	03 72 04             	add    0x4(%edx),%esi
 653:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 10                	mov    (%eax),%edx
 658:	8b 12                	mov    (%edx),%edx
 65a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 65d:	8b 50 04             	mov    0x4(%eax),%edx
 660:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 663:	39 f1                	cmp    %esi,%ecx
 665:	75 c6                	jne    62d <free+0x3d>
    p->s.size += bp->s.size;
 667:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 66a:	a3 20 08 00 00       	mov    %eax,0x820
    p->s.size += bp->s.size;
 66f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 672:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 675:	89 08                	mov    %ecx,(%eax)
}
 677:	5b                   	pop    %ebx
 678:	5e                   	pop    %esi
 679:	5f                   	pop    %edi
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 68c:	8b 15 20 08 00 00    	mov    0x820,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 692:	8d 78 07             	lea    0x7(%eax),%edi
 695:	c1 ef 03             	shr    $0x3,%edi
 698:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 69b:	85 d2                	test   %edx,%edx
 69d:	0f 84 8d 00 00 00    	je     730 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6a5:	8b 48 04             	mov    0x4(%eax),%ecx
 6a8:	39 f9                	cmp    %edi,%ecx
 6aa:	73 64                	jae    710 <malloc+0x90>
  if(nu < 4096)
 6ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b1:	39 df                	cmp    %ebx,%edi
 6b3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6b6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6bd:	eb 0a                	jmp    6c9 <malloc+0x49>
 6bf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6c2:	8b 48 04             	mov    0x4(%eax),%ecx
 6c5:	39 f9                	cmp    %edi,%ecx
 6c7:	73 47                	jae    710 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c9:	89 c2                	mov    %eax,%edx
 6cb:	3b 05 20 08 00 00    	cmp    0x820,%eax
 6d1:	75 ed                	jne    6c0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6d3:	83 ec 0c             	sub    $0xc,%esp
 6d6:	56                   	push   %esi
 6d7:	e8 9f fc ff ff       	call   37b <sbrk>
  if(p == (char*)-1)
 6dc:	83 c4 10             	add    $0x10,%esp
 6df:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e2:	74 1c                	je     700 <malloc+0x80>
  hp->s.size = nu;
 6e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	50                   	push   %eax
 6ee:	e8 fd fe ff ff       	call   5f0 <free>
  return freep;
 6f3:	8b 15 20 08 00 00    	mov    0x820,%edx
      if((p = morecore(nunits)) == 0)
 6f9:	83 c4 10             	add    $0x10,%esp
 6fc:	85 d2                	test   %edx,%edx
 6fe:	75 c0                	jne    6c0 <malloc+0x40>
        return 0;
  }
}
 700:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 703:	31 c0                	xor    %eax,%eax
}
 705:	5b                   	pop    %ebx
 706:	5e                   	pop    %esi
 707:	5f                   	pop    %edi
 708:	5d                   	pop    %ebp
 709:	c3                   	ret
 70a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 710:	39 cf                	cmp    %ecx,%edi
 712:	74 4c                	je     760 <malloc+0xe0>
        p->s.size -= nunits;
 714:	29 f9                	sub    %edi,%ecx
 716:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 719:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 71c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 71f:	89 15 20 08 00 00    	mov    %edx,0x820
}
 725:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 728:	83 c0 08             	add    $0x8,%eax
}
 72b:	5b                   	pop    %ebx
 72c:	5e                   	pop    %esi
 72d:	5f                   	pop    %edi
 72e:	5d                   	pop    %ebp
 72f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 730:	c7 05 20 08 00 00 24 	movl   $0x824,0x820
 737:	08 00 00 
    base.s.size = 0;
 73a:	b8 24 08 00 00       	mov    $0x824,%eax
    base.s.ptr = freep = prevp = &base;
 73f:	c7 05 24 08 00 00 24 	movl   $0x824,0x824
 746:	08 00 00 
    base.s.size = 0;
 749:	c7 05 28 08 00 00 00 	movl   $0x0,0x828
 750:	00 00 00 
    if(p->s.size >= nunits){
 753:	e9 54 ff ff ff       	jmp    6ac <malloc+0x2c>
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb b9                	jmp    71f <malloc+0x9f>
