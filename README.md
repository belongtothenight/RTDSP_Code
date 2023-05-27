# RTDSP_Code
 
## Codes

| No  | File                                                                                                                          | Functionality                                                                                        |
| --- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| 1.  | [w1_v1.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w1_v1.m)                                               | Sampling sinewave.                                                                                   |
| 2.  | [w1_v2.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w1_v2.m)                                               | Sampling sinewave.                                                                                   |
| 3.  | [w4_code1.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w4_code1.m)                                         | Filter sinewave.                                                                                     |
| 4.  | [w4_code2.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w4_code2.m)                                         | Sinewave DFT with enough resolution.                                                                 |
| 5.  | [w4_code3.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w4_code3.m)                                         | Sinewave DFT without enough resolution.                                                              |
| 6.  | [w5_code3_0.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code3_0.m)                                     | Function to generate pseudo-random uniform distribution number array.                                |
| 7.  | [w5_code3_1.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code3_1.m)                                     | Display mean value hist line multiple times.                                                         |
| 8.  | [w5_code3_2.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code3_2.m)                                     | Display variance value hist line multiple times.                                                     |
| 9.  | [w5_code3_3.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code3_3.m)                                     | Display mean & variance value hist line multiple times with zero-mean random number.                 |
| 10. | [w5_code3_4.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code3_4.m)                                     | Display mean & variance value hist line multiple times with zero-mean & unit-variance random number. |
| 11. | [w5_code3_5.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code3_5.m)                                     | Execute w5_code1 ~ w5_code3 in MatLab parpool.                                                       |
| 12. | [w5_code4_1.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code4_1.m)                                     | Generate sinewave corrupted by zero-mean & unit-variance white noise wiwth $SNR=0dB$.                |
| 13. | [w5_code4_2.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code4_2.m)                                     | Function version of w5_code4_1.m.                                                                    |
| 14. | [w5_code5_1.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code5_1.m)                                     | Computer homework assignment 1 Q1-1.                                                                 |
| 15. | [w5_code5_2.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code5_2.m)                                     | Computer homework assignment 1 Q1-2.                                                                 |
| 16. | [w5_code6.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code6.m)                                         | Computer homework assignment 1 Q2.                                                                   |
| 17. | [w5_code7.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w5_code7.m)                                         | Computer homework assignment 1 Q3.                                                                   |
| 18. | [w10_bessel.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w10_bessel.m)                                     | Try to design a bessel filter to match the requirement.                                              |
| 19. | [w11_loadAudio.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w11_loadAudio.m)                               | Audio loading script.                                                                                |
| 20. | [w11_dft.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w11_dft.m)                                           | Performing DFT with audio data and plots the result.                                                 |
| 21. | [w14_dft.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w11_dft.m)                                           | Performing DFT with audio data.                                                                      |
| 21. | [w14_readAudio.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w14_readAudio.m)                               | Read audio file.                                                                                     |
| 21. | [w14_acousticEchoCancellation.m](https://github.com/belongtothenight/RTDSP_Code/blob/main/src/w14_acousticEchoCancellation.m) | Perform acoustic echo cancellation with LMS filter.                                                  |

## Notes

1. "w1_v1.m" and "w1_v2.m" can't properly sample sinewave.
2. "w5_code3_0.m" can use the same method to generate zero-mean and unit-variance white noise with "w5_code4_1.m".
