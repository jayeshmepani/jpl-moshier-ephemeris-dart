#ifndef JME_H
#define JME_H

#include <stddef.h>

#define JME_JME_H 1
#define JME_VERSION "0.1.0"
#define JME_AU_KM 149597870.7
#define JME_SPEED_OF_LIGHT_KM_PER_SEC 299792.458
#define JME_SECONDS_PER_DAY 86400.0
#define JME_OK 0
#define JME_ERR -1
#define JME_CALENDAR_JULIAN 0
#define JME_CALENDAR_GREGORIAN 1
#define JME_BODY_SUN 0
#define JME_BODY_MOON 1
#define JME_BODY_MERCURY 2
#define JME_BODY_VENUS 3
#define JME_BODY_MARS 4
#define JME_BODY_JUPITER 5
#define JME_BODY_SATURN 6
#define JME_BODY_URANUS 7
#define JME_BODY_NEPTUNE 8
#define JME_BODY_PLUTO 9
#define JME_BODY_EARTH 10
#define JME_BODY_SOLAR_SYSTEM_BARYCENTER 11
#define JME_BODY_MERCURY_BARYCENTER 12
#define JME_BODY_VENUS_BARYCENTER 13
#define JME_BODY_EARTH_MOON_BARYCENTER 14
#define JME_BODY_MARS_BARYCENTER 15
#define JME_BODY_JUPITER_BARYCENTER 16
#define JME_BODY_SATURN_BARYCENTER 17
#define JME_BODY_URANUS_BARYCENTER 18
#define JME_BODY_NEPTUNE_BARYCENTER 19
#define JME_BODY_PLUTO_BARYCENTER 20
#define JME_BODY_MEAN_NODE 21
#define JME_BODY_TRUE_NODE 22
#define JME_CALC_NONE 0
#define JME_CALC_SPEED 1
#define JME_CALC_EQUATORIAL 2
#define JME_CALC_XYZ 4
#define JME_CALC_RADIANS 8
#define JME_CALC_BARYCENTRIC 16
#define JME_CALC_HELIOCENTRIC 32
#define JME_CALC_TRUE_POSITION 64
#define JME_CALC_J2000 128
#define JME_CALC_NO_NUTATION 256
#define JME_CALC_SIDEREAL 512
#define JME_SIDEREAL_FAGAN_BRADLEY 0
#define JME_SIDEREAL_LAHIRI 1
#define JME_SIDEREAL_USER 255
#define JME_VECTOR_AU_PER_DAY 0
#define JME_VECTOR_KM_PER_DAY 1
#define JME_VECTOR_AU_PER_SECOND 2
#define JME_VECTOR_KM_PER_SECOND 3
#define JME_ORIENTATION_RAD_PER_DAY 0
#define JME_ORIENTATION_RAD_PER_SECOND 1
#define JME_JPL_TIMESCALE_UNKNOWN 0
#define JME_JPL_TIMESCALE_TDB 1
#define JME_JPL_TIMESCALE_TCB 2
#define JME_EXTENDED_H 1
#define JME_ANGLE_FORMAT_KEEP_DEG 0
#define JME_ANGLE_FORMAT_KEEP_SIGN 1
#define JME_ANGLE_FORMAT_NAKSHATRA 2
#define JME_ANGLE_FORMAT_ROUND_DEG 3
#define JME_ANGLE_FORMAT_ROUND_MIN 4
#define JME_ANGLE_FORMAT_ROUND_SEC 5
#define JME_ANGLE_FORMAT_ZODIACAL 6
#define JME_BODY_ALTJIRA 7
#define JME_BODY_AMYCUS 8
#define JME_BODY_ARROKOTH 9
#define JME_BODY_ASBOLUS 10
#define JME_BODY_ASTEROID_001 11
#define JME_BODY_ASTEROID_002 12
#define JME_BODY_ASTEROID_003 13
#define JME_BODY_ASTEROID_004 14
#define JME_BODY_ASTEROID_005 15
#define JME_BODY_ASTEROID_006 16
#define JME_BODY_ASTEROID_007 17
#define JME_BODY_ASTEROID_008 18
#define JME_BODY_ASTEROID_009 19
#define JME_BODY_ASTEROID_010 20
#define JME_BODY_ASTEROID_011 21
#define JME_BODY_ASTEROID_012 22
#define JME_BODY_ASTEROID_013 23
#define JME_BODY_ASTEROID_014 24
#define JME_BODY_ASTEROID_015 25
#define JME_BODY_ASTEROID_016 26
#define JME_BODY_ASTEROID_017 27
#define JME_BODY_ASTEROID_018 28
#define JME_BODY_ASTEROID_019 29
#define JME_BODY_ASTEROID_020 30
#define JME_BODY_ASTEROID_021 31
#define JME_BODY_ASTEROID_022 32
#define JME_BODY_ASTEROID_023 33
#define JME_BODY_ASTEROID_024 34
#define JME_BODY_ASTEROID_025 35
#define JME_BODY_ASTEROID_026 36
#define JME_BODY_ASTEROID_027 37
#define JME_BODY_ASTEROID_028 38
#define JME_BODY_ASTEROID_029 39
#define JME_BODY_ASTEROID_030 40
#define JME_BODY_ASTEROID_031 41
#define JME_BODY_ASTEROID_032 42
#define JME_BODY_ASTEROID_033 43
#define JME_BODY_ASTEROID_034 44
#define JME_BODY_ASTEROID_035 45
#define JME_BODY_ASTEROID_036 46
#define JME_BODY_ASTEROID_037 47
#define JME_BODY_ASTEROID_038 48
#define JME_BODY_ASTEROID_039 49
#define JME_BODY_ASTEROID_040 50
#define JME_BODY_ASTEROID_041 51
#define JME_BODY_ASTEROID_042 52
#define JME_BODY_ASTEROID_043 53
#define JME_BODY_ASTEROID_044 54
#define JME_BODY_ASTEROID_045 55
#define JME_BODY_ASTEROID_046 56
#define JME_BODY_ASTEROID_047 57
#define JME_BODY_ASTEROID_048 58
#define JME_BODY_ASTEROID_049 59
#define JME_BODY_ASTEROID_050 60
#define JME_BODY_ASTEROID_051 61
#define JME_BODY_ASTEROID_052 62
#define JME_BODY_ASTEROID_053 63
#define JME_BODY_ASTEROID_054 64
#define JME_BODY_ASTEROID_055 65
#define JME_BODY_ASTEROID_056 66
#define JME_BODY_ASTEROID_057 67
#define JME_BODY_ASTEROID_058 68
#define JME_BODY_ASTEROID_059 69
#define JME_BODY_ASTEROID_060 70
#define JME_BODY_ASTEROID_061 71
#define JME_BODY_ASTEROID_062 72
#define JME_BODY_ASTEROID_063 73
#define JME_BODY_ASTEROID_064 74
#define JME_BODY_ASTEROID_065 75
#define JME_BODY_ASTEROID_066 76
#define JME_BODY_ASTEROID_067 77
#define JME_BODY_ASTEROID_068 78
#define JME_BODY_ASTEROID_069 79
#define JME_BODY_ASTEROID_070 80
#define JME_BODY_ASTEROID_071 81
#define JME_BODY_ASTEROID_072 82
#define JME_BODY_ASTEROID_073 83
#define JME_BODY_ASTEROID_074 84
#define JME_BODY_ASTEROID_075 85
#define JME_BODY_ASTEROID_076 86
#define JME_BODY_ASTEROID_077 87
#define JME_BODY_ASTEROID_078 88
#define JME_BODY_ASTEROID_079 89
#define JME_BODY_ASTEROID_080 90
#define JME_BODY_ASTEROID_081 91
#define JME_BODY_ASTEROID_082 92
#define JME_BODY_ASTEROID_083 93
#define JME_BODY_ASTEROID_084 94
#define JME_BODY_ASTEROID_085 95
#define JME_BODY_ASTEROID_086 96
#define JME_BODY_ASTEROID_087 97
#define JME_BODY_ASTEROID_088 98
#define JME_BODY_ASTEROID_089 99
#define JME_BODY_ASTEROID_090 100
#define JME_BODY_ASTEROID_091 101
#define JME_BODY_ASTEROID_092 102
#define JME_BODY_ASTEROID_093 103
#define JME_BODY_ASTEROID_094 104
#define JME_BODY_ASTEROID_095 105
#define JME_BODY_ASTEROID_096 106
#define JME_BODY_ASTEROID_097 107
#define JME_BODY_ASTEROID_098 108
#define JME_BODY_ASTEROID_099 109
#define JME_BODY_ASTEROID_100 110
#define JME_BODY_ASTEROID_101 111
#define JME_BODY_ASTEROID_102 112
#define JME_BODY_ASTEROID_103 113
#define JME_BODY_ASTEROID_104 114
#define JME_BODY_ASTEROID_105 115
#define JME_BODY_ASTEROID_106 116
#define JME_BODY_ASTEROID_107 117
#define JME_BODY_ASTEROID_108 118
#define JME_BODY_ASTEROID_109 119
#define JME_BODY_ASTEROID_110 120
#define JME_BODY_BIENOR 121
#define JME_BODY_BORASISI 122
#define JME_BODY_CERES 123
#define JME_BODY_CHARIKLO 124
#define JME_BODY_CHIRON 125
#define JME_BODY_COMET_001 126
#define JME_BODY_COMET_002 127
#define JME_BODY_COMET_003 128
#define JME_BODY_COMET_004 129
#define JME_BODY_COMET_005 130
#define JME_BODY_COMET_006 131
#define JME_BODY_COMET_007 132
#define JME_BODY_COMET_008 133
#define JME_BODY_COMET_009 134
#define JME_BODY_COMET_010 135
#define JME_BODY_COMET_011 136
#define JME_BODY_COMET_012 137
#define JME_BODY_COMET_013 138
#define JME_BODY_COMET_014 139
#define JME_BODY_COMET_015 140
#define JME_BODY_COMET_016 141
#define JME_BODY_COMET_017 142
#define JME_BODY_COMET_018 143
#define JME_BODY_COMET_019 144
#define JME_BODY_COMET_020 145
#define JME_BODY_COMET_021 146
#define JME_BODY_COMET_022 147
#define JME_BODY_COMET_023 148
#define JME_BODY_COMET_024 149
#define JME_BODY_COMET_025 150
#define JME_BODY_COMET_026 151
#define JME_BODY_COMET_027 152
#define JME_BODY_COMET_028 153
#define JME_BODY_COMET_029 154
#define JME_BODY_COMET_030 155
#define JME_BODY_COMET_031 156
#define JME_BODY_COMET_032 157
#define JME_BODY_COMET_033 158
#define JME_BODY_COMET_034 159
#define JME_BODY_COMET_035 160
#define JME_BODY_COMET_036 161
#define JME_BODY_COMET_037 162
#define JME_BODY_COMET_038 163
#define JME_BODY_COMET_039 164
#define JME_BODY_COMET_040 165
#define JME_BODY_COMET_041 166
#define JME_BODY_COMET_042 167
#define JME_BODY_COMET_043 168
#define JME_BODY_COMET_044 169
#define JME_BODY_COMET_045 170
#define JME_BODY_COMET_046 171
#define JME_BODY_COMET_047 172
#define JME_BODY_COMET_048 173
#define JME_BODY_COMET_049 174
#define JME_BODY_COMET_050 175
#define JME_BODY_COMET_051 176
#define JME_BODY_COMET_052 177
#define JME_BODY_COMET_053 178
#define JME_BODY_COMET_054 179
#define JME_BODY_COMET_055 180
#define JME_BODY_COMET_056 181
#define JME_BODY_COMET_057 182
#define JME_BODY_COMET_058 183
#define JME_BODY_COMET_059 184
#define JME_BODY_COMET_060 185
#define JME_BODY_CRANTOR 186
#define JME_BODY_CYLLARUS 187
#define JME_BODY_DEUCALION 188
#define JME_BODY_ECHECLUS 189
#define JME_BODY_ELATUS 190
#define JME_BODY_ERIS 191
#define JME_BODY_GONGGONG 192
#define JME_BODY_HAUMEA 193
#define JME_BODY_HUYA 194
#define JME_BODY_HYLONOME 195
#define JME_BODY_IXION 196
#define JME_BODY_JUNO 197
#define JME_BODY_MAKEMAKE 198
#define JME_BODY_MINOR_PLANET_001 199
#define JME_BODY_MINOR_PLANET_002 200
#define JME_BODY_MINOR_PLANET_003 201
#define JME_BODY_MINOR_PLANET_004 202
#define JME_BODY_MINOR_PLANET_005 203
#define JME_BODY_MINOR_PLANET_006 204
#define JME_BODY_MINOR_PLANET_007 205
#define JME_BODY_MINOR_PLANET_008 206
#define JME_BODY_MINOR_PLANET_009 207
#define JME_BODY_MINOR_PLANET_010 208
#define JME_BODY_MINOR_PLANET_011 209
#define JME_BODY_MINOR_PLANET_012 210
#define JME_BODY_MINOR_PLANET_013 211
#define JME_BODY_MINOR_PLANET_014 212
#define JME_BODY_MINOR_PLANET_015 213
#define JME_BODY_MINOR_PLANET_016 214
#define JME_BODY_MINOR_PLANET_017 215
#define JME_BODY_MINOR_PLANET_018 216
#define JME_BODY_MINOR_PLANET_019 217
#define JME_BODY_MINOR_PLANET_020 218
#define JME_BODY_MINOR_PLANET_021 219
#define JME_BODY_MINOR_PLANET_022 220
#define JME_BODY_MINOR_PLANET_023 221
#define JME_BODY_MINOR_PLANET_024 222
#define JME_BODY_MINOR_PLANET_025 223
#define JME_BODY_MINOR_PLANET_026 224
#define JME_BODY_MINOR_PLANET_027 225
#define JME_BODY_MINOR_PLANET_028 226
#define JME_BODY_MINOR_PLANET_029 227
#define JME_BODY_MINOR_PLANET_030 228
#define JME_BODY_MINOR_PLANET_031 229
#define JME_BODY_MINOR_PLANET_032 230
#define JME_BODY_MINOR_PLANET_033 231
#define JME_BODY_MINOR_PLANET_034 232
#define JME_BODY_MINOR_PLANET_035 233
#define JME_BODY_MINOR_PLANET_036 234
#define JME_BODY_MINOR_PLANET_037 235
#define JME_BODY_MINOR_PLANET_038 236
#define JME_BODY_MINOR_PLANET_039 237
#define JME_BODY_MINOR_PLANET_040 238
#define JME_BODY_MINOR_PLANET_041 239
#define JME_BODY_MINOR_PLANET_042 240
#define JME_BODY_MINOR_PLANET_043 241
#define JME_BODY_MINOR_PLANET_044 242
#define JME_BODY_MINOR_PLANET_045 243
#define JME_BODY_MINOR_PLANET_046 244
#define JME_BODY_MINOR_PLANET_047 245
#define JME_BODY_MINOR_PLANET_048 246
#define JME_BODY_MINOR_PLANET_049 247
#define JME_BODY_MINOR_PLANET_050 248
#define JME_BODY_MINOR_PLANET_051 249
#define JME_BODY_MINOR_PLANET_052 250
#define JME_BODY_MINOR_PLANET_053 251
#define JME_BODY_MINOR_PLANET_054 252
#define JME_BODY_MINOR_PLANET_055 253
#define JME_BODY_MINOR_PLANET_056 254
#define JME_BODY_MINOR_PLANET_057 255
#define JME_BODY_MINOR_PLANET_058 256
#define JME_BODY_MINOR_PLANET_059 257
#define JME_BODY_MINOR_PLANET_060 258
#define JME_BODY_NESSUS 259
#define JME_BODY_OKYRHOE 260
#define JME_BODY_ORCUS 261
#define JME_BODY_PALLAS 262
#define JME_BODY_PELOPS 263
#define JME_BODY_PHOLUS 264
#define JME_BODY_QUAOAR 265
#define JME_BODY_RHADAMANTHUS 266
#define JME_BODY_SALACIA 267
#define JME_BODY_SEDNA 268
#define JME_BODY_THEREUS 269
#define JME_BODY_TYTHONUS 270
#define JME_BODY_VARUNA 271
#define JME_BODY_VESTA 272
#define JME_CALC_APPARENT_POSITION 0
#define JME_CALC_ASTROMETRIC 3072
#define JME_CALC_CENTER_BODY 4096
#define JME_CALC_DISTANCE_AU 0
#define JME_CALC_DISTANCE_KM 8192
#define JME_CALC_HIGH_PRECISION 16384
#define JME_CALC_ICRS 32768
#define JME_CALC_NO_ABERRATION 1024
#define JME_CALC_NO_LIGHT_DEFLECTION 2048
#define JME_CALC_RAW_VECTOR 4
#define JME_CALC_RECTANGULAR 4
#define JME_CALC_SPHERICAL 0
#define JME_CALC_STRICT 65536
#define JME_CALC_TOPOCENTRIC 131072
#define JME_CALC_VELOCITY_PER_DAY 0
#define JME_CALC_VELOCITY_PER_SECOND 262144
#define JME_COORD_APPARENT_TO_TRUE 289
#define JME_COORD_ECLIPTIC_TO_HORIZONTAL 290
#define JME_COORD_EQUATORIAL_TO_HORIZONTAL 291
#define JME_COORD_HORIZONTAL_TO_ECLIPTIC 292
#define JME_COORD_HORIZONTAL_TO_EQUATORIAL 293
#define JME_COORD_TRUE_TO_APPARENT 294
#define JME_ECLIPSE_FIRST_CONTACT 295
#define JME_ECLIPSE_FOURTH_CONTACT 296
#define JME_ECLIPSE_LUNAR_PARTIAL 297
#define JME_ECLIPSE_LUNAR_PENUMBRAL 298
#define JME_ECLIPSE_LUNAR_TOTAL 299
#define JME_ECLIPSE_MAX_VISIBLE 300
#define JME_ECLIPSE_PENUMBRAL_BEGIN 301
#define JME_ECLIPSE_PENUMBRAL_END 302
#define JME_ECLIPSE_SECOND_CONTACT 303
#define JME_ECLIPSE_SOLAR_ANNULAR 304
#define JME_ECLIPSE_SOLAR_CENTRAL 305
#define JME_ECLIPSE_SOLAR_HYBRID 306
#define JME_ECLIPSE_SOLAR_NONCENTRAL 307
#define JME_ECLIPSE_SOLAR_PARTIAL 308
#define JME_ECLIPSE_SOLAR_TOTAL 309
#define JME_ECLIPSE_THIRD_CONTACT 310
#define JME_ECLIPSE_VISIBLE 311
#define JME_HOUSE_ALCABITIUS 312
#define JME_HOUSE_APC 313
#define JME_HOUSE_AZIMUTHAL 314
#define JME_HOUSE_CAMPANUS 315
#define JME_HOUSE_EQUAL 316
#define JME_HOUSE_GAUQUELIN 317
#define JME_HOUSE_HORIZONTAL 318
#define JME_HOUSE_KOCH 319
#define JME_HOUSE_KRUSINSKI 320
#define JME_HOUSE_MERIDIAN 321
#define JME_HOUSE_MORINUS 322
#define JME_HOUSE_PLACIDUS 323
#define JME_HOUSE_POLICH_PAGE 324
#define JME_HOUSE_PORPHYRIUS 325
#define JME_HOUSE_REGIOMONTANUS 326
#define JME_HOUSE_SUNSHINE 327
#define JME_HOUSE_VEHLOW_EQUAL 328
#define JME_HOUSE_WHOLE_SIGN 329
#define JME_MODEL_BIAS_IAU2000 330
#define JME_MODEL_BIAS_IAU2006 331
#define JME_MODEL_BIAS_NONE 332
#define JME_MODEL_NUT_IAU_1980 333
#define JME_MODEL_NUT_IAU_2000A 334
#define JME_MODEL_NUT_IAU_2000B 335
#define JME_MODEL_OBL_IAU_1980 336
#define JME_MODEL_OBL_IAU_2000 337
#define JME_MODEL_OBL_IAU_2006 338
#define JME_MODEL_PREC_IAU_1976 339
#define JME_MODEL_PREC_IAU_2000 340
#define JME_MODEL_PREC_IAU_2006 341
#define JME_MODEL_PREC_LASKAR_1986 342
#define JME_MODEL_PREC_VONDRAK_2011 343
#define JME_MODEL_SIDT_IAU_1976 344
#define JME_MODEL_SIDT_IAU_2006 345
#define JME_MODEL_DELTAT_STEPHENSON_MORRISON_1984 346
#define JME_MODEL_DELTAT_STEPHENSON_1997 347
#define JME_MODEL_DELTAT_STEPHENSON_MORRISON_2004 348
#define JME_MODEL_DELTAT_ESPENAK_MEEUS_2006 349
#define JME_MODEL_DELTAT_STEPHENSON_ETC_2016 350
#define JME_RISE_ANTI_MERIDIAN_TRANSIT 8
#define JME_RISE_ASTRONOMICAL_TWILIGHT 512
#define JME_RISE_CIVIL_TWILIGHT 128
#define JME_RISE_DISC_BOTTOM 2048
#define JME_RISE_DISC_CENTER 256
#define JME_RISE_FIXED_DISC_SIZE 1024
#define JME_RISE_HINDU_RISING 4096
#define JME_RISE_MERIDIAN_TRANSIT 4
#define JME_RISE_NAUTICAL_TWILIGHT 64
#define JME_RISE_NO_REFRACTION 8192
#define JME_RISE_RISE 1
#define JME_RISE_SET 2
#define JME_SIDEREAL_ALDEBARAN_15TAU 363
#define JME_SIDEREAL_ARYABHATA 364
#define JME_SIDEREAL_B1950 365
#define JME_SIDEREAL_BABYL_ETPSC 366
#define JME_SIDEREAL_BABYL_HUBER 367
#define JME_SIDEREAL_BABYL_KUGLER1 368
#define JME_SIDEREAL_BABYL_KUGLER2 369
#define JME_SIDEREAL_BABYL_KUGLER3 370
#define JME_SIDEREAL_DELUCE 371
#define JME_SIDEREAL_GALCENT_0SAG 372
#define JME_SIDEREAL_HIPPARCHOS 373
#define JME_SIDEREAL_J1900 374
#define JME_SIDEREAL_J2000 375
#define JME_SIDEREAL_JN_BHASIN 376
#define JME_SIDEREAL_KRISHNAMURTI 377
#define JME_SIDEREAL_RAMAN 378
#define JME_SIDEREAL_SASSANIAN 379
#define JME_SIDEREAL_SS_CITRA 380
#define JME_SIDEREAL_SS_REVATI 381
#define JME_SIDEREAL_SURYASIDDHANTA 382
#define JME_SIDEREAL_TRUE_CITRA 383
#define JME_SIDEREAL_TRUE_MULA 384
#define JME_SIDEREAL_TRUE_PUSHYA 385
#define JME_SIDEREAL_TRUE_REVATI 386
#define JME_SIDEREAL_USHASHASHI 387
#define JME_SIDEREAL_YUKTESHWAR 388
#define JME_TIME_DELTAT_AUTOMATIC 389
#define JME_TIME_TIDAL_AUTOMATIC 390
#define JME_TIME_TIDAL_DE200 391
#define JME_TIME_TIDAL_DE403 392
#define JME_TIME_TIDAL_DE404 393
#define JME_TIME_TIDAL_DE405 394
#define JME_TIME_TIDAL_DE406 395
#define JME_TIME_TIDAL_DE421 396
#define JME_TIME_TIDAL_DE430 397
#define JME_TIME_TIDAL_DE431 398
#define JME_TIME_TIDAL_DE441 399
#define JME_VERSION_ID 400
#define JME_MODEL_REVISED_IAU_2000 401
#define JME_MODEL_REVISED_IAU_2006 402
#define JME_MODEL_REVISED_PREC_LASKAR 403
#define JME_MODEL_REVISED_PREC_VONDRAK 404
#define JME_MODEL_REVISED_PREC_LIESKE 405


            int jme_body_id_from_name(const char *name);
            int jme_body_naif_id(int body);
            int jme_calc(double jd_et, int body, int flags, double *results, char *error);
            int jme_calc_pctr(double jd_et, int body, int center, int flags, double *results, char *error);
            int jme_calc_ut(double jd_ut, int body, int flags, double *results, char *error);
            int jme_calendar_is_leap_year(int year, int calendar);
            int jme_centiseconds_difference(int p1, int p2);
            int jme_centiseconds_difference_signed(int p1, int p2);
            int jme_centiseconds_normalize(int p);
            int jme_centiseconds_round_second(int x);
            void jme_close(void);
            int jme_date_is_valid(int year, int month, int day, int calendar);
            int jme_day_of_week(double jd);
            int jme_day_of_year(int year, int month, int day, int calendar);
            int jme_days_in_month(int year, int month, int calendar);
            double jme_decimal_hour(int hour, int minute, double second);
            double jme_degree_midpoint(double x1, double x0);
            double jme_degree_normalize(double x);
            double jme_degrees_difference(double p1, double p2);
            double jme_degrees_difference_signed(double p1, double p2);
            double jme_degrees_to_hours(double degrees);
            double jme_degrees_to_radians(double degrees);
            double jme_delta_t(double jd_ut);
            double jme_delta_t_ex(double jd_ut, int model, char *error);
            int jme_double_to_long(double x);
            void jme_ecliptic_to_equatorial( double lon, double lat, double eps, double *ra, double *dec );
            int jme_ecliptic_to_equatorial_rectangular_state( const double *ecliptic, double eps, double *equatorial );
            int jme_elp2000_moon_state(double jd_et, double *results);
            void jme_equatorial_to_ecliptic( double ra, double dec, double eps, double *lon, double *lat );
            int jme_equatorial_to_ecliptic_rectangular_state( const double *equatorial, double eps, double *ecliptic );
            void jme_equatorial_to_horizontal( double hour_angle, double dec, double geo_lat, double *azimuth, double *altitude );
            int jme_fixstar(const char *star, double jd_et, int flags, double *results, char *error);
            int jme_fixstar_mag(const char *star, double *mag, char *error);
            int jme_fixstar_ut(const char *star, double jd_ut, int flags, double *results, char *error);
            int jme_fixstar2(const char *star, double jd_et, int flags, double *results, char *error);
            int jme_fixstar2_mag(const char *star, double *mag, char *error);
            int jme_fixstar2_ut(const char *star, double jd_ut, int flags, double *results, char *error);
            int jme_gauquelin_sector(double jd_ut, int body, const char *starname, int flags, int imeth, double *geopos, double atpress, double attemp, double *dgsect, char *error);
            int jme_get_astro_models(char *models, int flags);
            double jme_get_ayanamsa(double jd_et);
            int jme_get_ayanamsa_ex(double jd_et, int model, double *ayan, char *error);
            int jme_get_ayanamsa_ex_ut(double jd_ut, int model, double *ayan, char *error);
            double jme_get_ayanamsa_ut(double jd_ut);
            int jme_get_nutation(double jd_et, int model, double *dpsi, double *deps, char *error);
            void jme_get_nutation_matrix(double dpsi_rad, double deps_rad, double eps_rad, double *m);
            int jme_get_obliquity(double jd_et, int model, double *eps, char *error);
            int jme_get_orbital_elements(double jd_et, int body, int flags, double *elem, char *error);
            int jme_get_precession_matrix(double jd_start, double jd_end, int model, double *m);
            void jme_get_sidereal_mode(int *sidereal_mode, double *t0, double *ayan_t0);
            double jme_get_tid_acc(void);
            int jme_get_topo_pos(double jd_et, double *pos_au, char *error);
            double jme_heliacal_angle(double jd_ut, double *geopos, double *dat_hel, char *error);
            int jme_heliacal_pheno_ut(double jd_ut, double *geopos, double *dat_hel, char *error);
            int jme_heliacal_ut(double jd_ut, double *geopos, double *dat_hel, char *error);
            int jme_helio_cross(int body, double x2cross, double jd_ut, int flags, double *tret, char *error);
            int jme_helio_cross_ut(int body, double x2cross, double jd_ut, int flags, double *tret, char *error);
            void jme_horizontal_to_equatorial( double azimuth, double altitude, double geo_lat, double *hour_angle, double *dec );
            double jme_hours_normalize(double hours);
            double jme_hours_to_degrees(double hours);
            double jme_house_pos(double armc, double geo_lat, double eps, int house_system, double *xpin, char *error);
            int jme_houses(double jd_ut, double geo_lat, double geo_lon, int house_system, double *cusps, double *ascmc);
            int jme_houses_armc(double armc, double geo_lat, double eps, int house_system, double *cusps, double *ascmc);
            int jme_houses_armc_ex2(double armc, double geo_lat, double eps, int house_system, double *cusps, double *ascmc, double *cusps_speed, double *ascmc_speed);
            int jme_houses_ex(double jd_ut, int flags, double geo_lat, double geo_lon, int house_system, double *cusps, double *ascmc);
            int jme_houses_ex2(double jd_ut, int flags, double geo_lat, double geo_lon, int house_system, double *cusps, double *ascmc, double *cusps_speed, double *ascmc_speed);
            double jme_jd_add_seconds(double jd, double seconds);
            double jme_jd_difference_seconds(double jd_end, double jd_start);
            void jme_jd_to_utc( double jd, int calendar, int *year, int *month, int *day, int *hour, int *minute, double *second );
            int jme_jpl_body_state( double jd_time, int target_body, int center_body, int unit, double *state, char *error );
            int jme_jpl_body_state_naif( double jd_time, int target_naif, int center_naif, int unit, double *state, char *error );
            int jme_jpl_body_state_native( double jd_time, int target_body, int center_body, double *state, char *error );
            int jme_jpl_body_state_native_naif( double jd_time, int target_naif, int center_naif, double *state, char *error );
            int jme_jpl_body_state_native_split( double jd0, double time_offset, int target_body, int center_body, double *state, char *error );
            int jme_jpl_body_state_native_split_naif( double jd0, double time_offset, int target_naif, int center_naif, double *state, char *error );
            int jme_jpl_body_state_order( double jd0, double time_offset, int target_body, int center_body, int unit, int order, double *state, char *error );
            int jme_jpl_body_state_order_naif( double jd0, double time_offset, int target_naif, int center_naif, int unit, int order, double *state, char *error );
            int jme_jpl_body_state_split( double jd0, double time_offset, int target_body, int center_body, int unit, double *state, char *error );
            int jme_jpl_body_state_split_naif( double jd0, double time_offset, int target_naif, int center_naif, int unit, double *state, char *error );
            int jme_jpl_body_state_utc( int year, int month, int day, int hour, int minute, double second, int calendar, int target_body, int center_body, int unit, double *state, char *error );
            int jme_jpl_body_state_utc_naif( int year, int month, int day, int hour, int minute, double second, int calendar, int target_naif, int center_naif, int unit, double *state, char *error );
            void jme_jpl_close(void);
            int jme_jpl_constant(const char *name, double *value, char *error);
            int jme_jpl_constant_count(char *error);
            int jme_jpl_constant_index(int index, char *name, unsigned int name_size, double *value, char *error);
            int jme_jpl_constant_string(const char *name, char *value, unsigned int value_size, char *error);
            int jme_jpl_constant_string_vector( const char *name, char *values, unsigned int single_value_size, int value_count, char *error );
            int jme_jpl_constant_vector(const char *name, double *values, int value_count, char *error);
            int jme_jpl_coverage(double *first_time, double *last_time, int *continuous, char *error);
            int jme_jpl_current_file_data( char *path, unsigned int path_size, double *first_time, double *last_time, int *continuous, char *error );
            int jme_jpl_ecliptic_state( double jd_time, int target_body, int center_body, int unit, double *state, char *error );
            int jme_jpl_ecliptic_state_naif( double jd_time, int target_naif, int center_naif, int unit, double *state, char *error );
            int jme_jpl_ecliptic_state_split( double jd0, double time_offset, int target_body, int center_body, int unit, double *state, char *error );
            int jme_jpl_ecliptic_state_split_naif( double jd0, double time_offset, int target_naif, int center_naif, int unit, double *state, char *error );
            int jme_jpl_ecliptic_state_utc( int year, int month, int day, int hour, int minute, double second, int calendar, int target_body, int center_body, int unit, double *state, char *error );
            int jme_jpl_ecliptic_state_utc_naif( int year, int month, int day, int hour, int minute, double second, int calendar, int target_naif, int center_naif, int unit, double *state, char *error );
            int jme_jpl_file_version(char *buffer, unsigned int buffer_size, char *error);
            int jme_jpl_id_by_name(const char *name, int *id, char *error);
            int jme_jpl_is_available(void);
            int jme_jpl_is_open(void);
            int jme_jpl_is_thread_safe(char *error);
            int jme_jpl_max_supported_order(int segment_type);
            int jme_jpl_name_by_id(int id, char *name, unsigned int name_size, char *error);
            int jme_jpl_open(const char *path, char *error);
            int jme_jpl_open_array(int path_count, const char *const *paths, char *error);
            int jme_jpl_orientation_record_count(char *error);
            int jme_jpl_orientation_record_index( int index, int *target, double *first_time, double *last_time, int *frame, int *segment_type, char *error );
            int jme_jpl_orientation_state_naif( double jd_time, int target_naif, int unit, double *state, char *error );
            int jme_jpl_orientation_state_order_naif( double jd0, double time_offset, int target_naif, int unit, int order, double *state, char *error );
            int jme_jpl_orientation_state_split_naif( double jd0, double time_offset, int target_naif, int unit, double *state, char *error );
            int jme_jpl_orientation_state_utc_naif( int year, int month, int day, int hour, int minute, double second, int calendar, int target_naif, int unit, double *state, char *error );
            int jme_jpl_position_record_count(char *error);
            int jme_jpl_position_record_index( int index, int *target, int *center, double *first_time, double *last_time, int *frame, int *segment_type, char *error );
            int jme_jpl_prefetch(char *error);
            int jme_jpl_rotational_angular_momentum_state_naif( double jd_time, int target_naif, int unit, double *state, char *error );
            int jme_jpl_rotational_angular_momentum_state_order_naif( double jd0, double time_offset, int target_naif, int unit, int order, double *state, char *error );
            int jme_jpl_rotational_angular_momentum_state_split_naif( double jd0, double time_offset, int target_naif, int unit, double *state, char *error );
            int jme_jpl_rotational_angular_momentum_state_utc_naif( int year, int month, int day, int hour, int minute, double second, int calendar, int target_naif, int unit, double *state, char *error );
            int jme_jpl_timescale(void);
            double jme_julian_day(int year, int month, int day, double hour, int calendar);
            int jme_lat_to_lmt(double jd_lat, double geo_lon, double *jd_lmt, char *error);
            int jme_lmt_to_lat(double jd_lmt, double geo_lon, double *jd_lat, char *error);
            int jme_lun_eclipse_how(double jd_ut, int flags, double *geopos, double *attr, char *error);
            int jme_lun_eclipse_when(double jd_start, int flags, int iflag, double *tret, int backward, char *error);
            int jme_lun_eclipse_when_loc(double jd_start, int flags, double *geopos, double *tret, double *attr, int backward, char *error);
            int jme_lun_occult_when_glob(double jd_start, int body, const char *starname, int flags, int iflag, double *tret, int backward, char *error);
            int jme_lun_occult_when_loc(double jd_start, int body, const char *starname, int flags, double *geopos, double *tret, double *attr, int backward, char *error);
            int jme_lun_occult_where(double jd_ut, int body, const char *starname, int flags, double *geopos, double *attr, char *error);
            void jme_matrix_identity(double *m);
            void jme_matrix_multiply(const double *a, const double *b, double *out);
            void jme_matrix_rotate_x(double angle_rad, double *m);
            void jme_matrix_rotate_y(double angle_rad, double *m);
            void jme_matrix_rotate_z(double angle_rad, double *m);
            void jme_matrix_transform_state(const double *m, const double *input, double *output);
            int jme_meeus_moon_state(double jd_et, double *results);
            int jme_meeus_planet_state(double jd_et, int body, double *results);
            int jme_meeus_sun_state(double jd_et, double *results);
            int jme_mooncross(double x2cross, double jd_ut, int flags, double *tret, char *error);
            int jme_mooncross_node(double jd_ut, int flags, double *tret, char *error);
            int jme_mooncross_node_ut(double jd_ut, int flags, double *tret, char *error);
            int jme_mooncross_ut(double x2cross, double jd_ut, int flags, double *tret, char *error);
            int jme_moshier_planet_state(double jd_et, int body, double *results);
            int jme_nod_aps(double jd_et, int body, int flags, int method, double *tret, char *error);
            int jme_nod_aps_ut(double jd_ut, int body, int flags, int method, double *tret, char *error);
            int jme_orbit_max_min_true_distance(double jd_et, int body, int flags, double *tmax, double *tmin, double *dmax, double *dmin, char *error);
            int jme_pheno(double jd_et, int body, int flags, double *attr, char *error);
            int jme_pheno_ut(double jd_ut, int body, int flags, double *attr, char *error);
            double jme_radian_midpoint(double x1, double x0);
            double jme_radian_normalize(double x);
            double jme_radians_difference_signed(double p1, double p2);
            double jme_radians_to_degrees(double radians);
            int jme_rectangular_to_spherical_state(const double *rectangular, double *spherical);
            double jme_refract(double altitude, double pressure, double temperature, int calc_flag);
            double jme_refract_extended( double altitude, double geoalt, double pressure, double temperature, double lapse_rate, int calc_flag, double *out );
            void jme_reverse_julian_day( double jd, int calendar, int *year, int *month, int *day, double *hour );
            int jme_rise_trans(double jd_ut, int body, const char *starname, int flags, int rsmi, double *geopos, double atpress, double attemp, double *tret, char *error);
            int jme_rise_trans_true_hor(double jd_ut, int body, const char *starname, int flags, int rsmi, double *geopos, double atpress, double attemp, double horhgt, double *tret, char *error);
            void jme_set_astro_models(const char *models, int flags);
            void jme_set_delta_t_userdef(double dt);
            void jme_set_ephemeris_path(const char *path);
            void jme_set_interpolate_nut(int on);
            void jme_set_jpl_file(const char *path);
            void jme_set_lapse_rate(double lapse_rate);
            void jme_set_sidereal_mode(int sidereal_mode, double t0, double ayan_t0);
            void jme_set_tid_acc(double t_acc);
            void jme_set_topo(double lon, double lat, double altitude);
            double jme_sidereal_time(double jd_ut);
            double jme_sidereal_time0(double jd_ut, double eps, double nut);
            int jme_sol_eclipse_how(double jd_ut, int flags, double *geopos, double *attr, char *error);
            int jme_sol_eclipse_when_glob(double jd_start, int flags, int epheflag, double *tret, int backward, char *error);
            int jme_sol_eclipse_when_loc(double jd_start, int flags, double *geopos, double *tret, double *attr, int backward, char *error);
            int jme_sol_eclipse_where(double jd_ut, int flags, double *geopos, double *attr, char *error);
            int jme_solcross(double x2cross, double jd_ut, int flags, double *tret, char *error);
            int jme_solcross_ut(double x2cross, double jd_ut, int flags, double *tret, char *error);
            double jme_spherical_angular_separation(double lon1, double lat1, double lon2, double lat2);
            double jme_spherical_position_angle(double lon1, double lat1, double lon2, double lat2);
            int jme_spherical_to_rectangular_state(const double *spherical, double *rectangular);
            void jme_split_degree( double ddeg, int roundflag, int *ideg, int *imin, int *isec, double *dsecfr, int *isgn );
            int jme_state_add(const double *left, const double *right, double *output);
            int jme_state_convert_units(const double *input, int input_unit, int output_unit, double *output);
            double jme_state_distance(const double *state);
            double jme_state_light_time_days(const double *state, int unit);
            double jme_state_position_velocity_dot(const double *state);
            int jme_state_scale(const double *input, double factor, double *output);
            double jme_state_speed(const double *state);
            int jme_state_subtract(const double *left, const double *right, double *output);
            int jme_time_equ(double jd_ut, double *e, char *error);
            double jme_topo_arcus_visionis(double jd_ut, double *geopos, double *dat_hel, char *error);
            void jme_utc_time_zone( int year, int month, int day, int hour, int minute, double second, double timezone, int *out_year, int *out_month, int *out_day, int *out_hour, int *out_minute, double *out_second );
            int jme_utc_to_jd( int year, int month, int day, int hour, int minute, double second, int calendar, double *jd_utc );
            int jme_vis_limit_mag(double jd_ut, double *geopos, double *dat_hel, char *error);
            int jme_vsop87_planet_state(double jd_et, int body, double *results);
            int jme_get_frame_bias_matrix(int model, double *m);
            const char *jme_body_name(int body);
            char *jme_centiseconds_to_degree_string(int cs, char *buffer);
            char *jme_centiseconds_to_lonlat_string(int cs, char *buffer);
            char *jme_centiseconds_to_time_string(int cs, char *buffer);
            char *jme_copy_body_name(int body, char *buffer);
            const char *jme_ephemeris_path(void);
            const char *jme_get_ayanamsa_name(int model);
            const char *jme_house_system_name(int house_system);
            const char *jme_jpl_engine_version(char *buffer, size_t buffer_size);
            const char *jme_jpl_file(void);
            const char *jme_library_path(void);
            const char *jme_version(char *buffer, size_t buffer_size);

#endif // JME_H
