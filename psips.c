/* psips.c */

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

enum {
  NUT_UNSPECIFIED                  =  0,  // Unspecified
  NUT_CODED_SLICE_NON_IDR          =  1,  // Coded slice of a non-IDR picture
  NUT_CODED_SLICE_DATA_PARTITION_A =  2,  // Coded slice data partition A
  NUT_CODED_SLICE_DATA_PARTITION_B =  3,  // Coded slice data partition B
  NUT_CODED_SLICE_DATA_PARTITION_C =  4,  // Coded slice data partition C
  NUT_CODED_SLICE_IDR              =  5,  // Coded slice of an IDR picture
  NUT_SEI                          =  6,  // Supplemental enhancement information (SEI)
  NUT_SPS                          =  7,  // Sequence parameter set
  NUT_PPS                          =  8,  // Picture parameter set
  NUT_AUD                          =  9,  // Access unit delimiter
  NUT_END_OF_SEQUENCE              = 10,  // End of sequence
  NUT_END_OF_STREAM                = 11,  // End of stream
  NUT_FILLER                       = 12,  // Filler data
  NUT_SPS_EXT                      = 13,  // Sequence parameter set extension
  NUT_CODED_SLICE_AUX              = 19   // Slice of an auxiliary coded pic w/o part
};

static void die(const char *msg, ...) {
  va_list ap;
  va_start(ap, msg);
  fprintf(stderr, "Fatal: ");
  vfprintf(stderr, msg, ap);
  fprintf(stderr, "\n");
  exit(1);
}

static size_t put_out(uint8_t *buf, size_t len) {
  ssize_t put = write(1, buf, len);
  if (put < 0) die("Write error: %m");
  if (put != (ssize_t) len) die("Short write");
  return len;
}

static size_t push_out(uint8_t **buf, size_t len) {
  put_out(*buf, len);
  *buf += len;
  return len;
}

int main(void) {
  uint8_t buf[1 << 16], *out;
  uint8_t state = 0;
  unsigned i, j, type = 0x20;

  struct {
    uint8_t buf[256];
    unsigned pos;
  } psbuf[2], *cps = NULL;

  for (;;) {
    ssize_t got = read(0, (out = buf), sizeof(buf));
    if (got < 0) die("Read error: %m");
    if (got == 0) break;
    for (i = 0; i < (unsigned) got; i++) {
      switch (state) {
      case 0x57: /* 0x00000001 */
        type = buf[i] & 0x1F;
        switch (type) {
        case NUT_SPS:
        case NUT_PPS:
          /* if we have PPS/SPS record it in the appropriate buffer */
          cps = &psbuf[type == NUT_SPS ? 0 : 1 ];
          cps->pos = 0;
          break;
        case NUT_CODED_SLICE_IDR:
          /* If we have an IDR (key) frame push the stored SPS/PPS out in front of it */
          if (!cps) {
            got -= push_out(&out, &buf[i] - out);
            for (j = 0; j < 2; j++)
              put_out(psbuf[j].buf, psbuf[j].pos);
          }

        default:
          /* Anything other than SPS/PPS: stop recording */
          cps = NULL;
          break;
        }
        break;
      }
      /* state of last four bytes packed into one byte; two bits for unseen/zero/over
       * one/one (0..3 respectively).
       */
      state = (state << 2) | (buf[i] == 0x00 ? 1 : buf[i] == 0x01 ? 3 : 2);
      if (cps) {
        if (cps->pos == sizeof(cps->buf)) {
          fprintf(stderr, "Warning: SPS/PPS overrun!\n");
          /* discard and forget about it. SPS/PPS are quite small -
           * if this buffer fills it's more likely that we're being
           * given something other than h264 than that the SPS or PPS is
           * that large. 
           */
          cps->pos = 0;
          cps = NULL;
        }
        cps->buf[cps->pos++] = buf[i];
      }
    }
    /* push whatever is left at the end */
    push_out(&out, got);
  }

  return 0;
}

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
