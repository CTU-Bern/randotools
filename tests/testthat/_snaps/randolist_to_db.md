# randolist_to_db issues warning for secuTrial and ignores rando_enc

    Code
      randolist_to_db(r, target_db = "secuTrial", rando_enc = r_enc, strata_enc = s_enc)
    Condition
      Warning in `randolist_to_db()`:
      rando_enc ignored for secuTrial
      Warning in `randolist_to_db()`:
      The SecuTrial target is untested and may require some adjustment
    Output
         Number Group       sex
      1       1    T1 value = 1
      2       2    T1 value = 1
      3       3    T2 value = 1
      4       4    T2 value = 1
      5       5    T2 value = 1
      6       6    T1 value = 1
      7       7    T2 value = 1
      8       8    T1 value = 1
      9       9    T1 value = 2
      10     10    T1 value = 2
      11     11    T2 value = 2
      12     12    T2 value = 2
      13     13    T1 value = 2
      14     14    T1 value = 2
      15     15    T1 value = 2
      16     16    T2 value = 2
      17     17    T2 value = 2
      18     18    T2 value = 2

