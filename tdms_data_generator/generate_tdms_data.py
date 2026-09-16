"""
TDMS Electrical TRD Synthetic Data Generator
Generates realistic Indian Railways Traction Distribution (TRD), OHE, Power Block, 
and Traffic Block records for the IMBPS project.

Date range: 2026-09-15 to 2027-03-15
"""

import os
import random
from datetime import datetime, date, timedelta
import numpy as np

# Deterministic randomness
random.seed(42)
np.random.seed(42)

# Railway hierarchy and locations
RAILWAY_MASTER = {
    "ECR": {
        "zone_name": "East Central Railway",
        "divisions": {
            "DDU": {
                "name": "Pt. Deen Dayal Upadhyaya (DDU)",
                "sections": [
                    {
                        "section": "DDU - BDL",
                        "block_sections": [
                            ("Pt. Deen Dayal Upadhyaya (DDU) - Kuchman (KCA)", 665.0, 672.0),
                            ("Kuchman (KCA) - Sakaldiha (SLD)", 672.0, 679.5),
                            ("Sakaldiha (SLD) - Tulsi Ashram (TLAM)", 679.5, 686.2),
                            ("Tulsi Ashram (TLAM) - Chandauli Majhwar (CDMR)", 686.2, 693.8),
                            ("Chandauli Majhwar (CDMR) - Saidraja (SYJ)", 693.8, 702.4),
                            ("Saidraja (SYJ) - Karamnasa (KMS)", 702.4, 709.6),
                            ("Karamnasa (KMS) - Bhabua Road (BBU)", 709.6, 718.0)
                        ],
                        "tss": ["Chandauli TSS", "Sakaldiha TSS", "Karamnasa TSS", "Bhabua TSS"],
                        "fps": ["FP-01 (KCA)", "FP-02 (CDMR)", "FP-03 (SYJ)", "FP-04 (BBU)"],
                        "lines": ["UP Main Line", "DOWN Main Line", "UP Loop Line", "DOWN Loop Line"]
                    },
                    {
                        "section": "DDU - Gaya",
                        "block_sections": [
                            ("Kudra (KTQ) - Sasaram (SSM)", 595.0, 608.2),
                            ("Sasaram (SSM) - Dehri-on-Sone (DOS)", 608.2, 626.5),
                            ("Dehri-on-Sone (DOS) - Son Nagar (SEB)", 626.5, 632.0),
                            ("Son Nagar (SEB) - Anugraha Narayan Road (AUBR)", 632.0, 645.0),
                            ("Anugraha Narayan Road (AUBR) - Rafiganj (RFJ)", 645.0, 661.0),
                            ("Guraru (GRRU) - Gaya (GAYA)", 675.0, 692.0)
                        ],
                        "tss": ["Sasaram TSS", "Dehri TSS", "Rafiganj TSS", "Gaya TSS"],
                        "fps": ["FP-SSM-01", "FP-DOS-02", "FP-RFJ-01", "FP-GAYA-02"],
                        "lines": ["UP Main Line", "DOWN Main Line", "UP Grand Chord", "DN Grand Chord"]
                    },
                    {
                        "section": "DDU - Sasaram Corridor",
                        "block_sections": [
                            ("Bhabua Road (BBU) - Muthani (MTGE)", 580.0, 588.5),
                            ("Muthani (MTGE) - Kudra (KTQ)", 588.5, 595.0),
                            ("Kudra (KTQ) - Sasaram (SSM)", 595.0, 608.2)
                        ],
                        "tss": ["Bhabua TSS", "Sasaram TSS"],
                        "fps": ["FP-BBU-01", "FP-SSM-02"],
                        "lines": ["UP Main Line", "DOWN Main Line", "Yard Line", "Goods Loop"]
                    }
                ]
            },
            "DNR": {
                "name": "Danapur (DNR)",
                "sections": [
                    {
                        "section": "DNR - ARA - BXR",
                        "block_sections": [
                            ("Danapur (DNR) - Bihta (BTA)", 550.0, 566.0),
                            ("Bihta (BTA) - Ara (ARA)", 566.0, 589.0),
                            ("Ara (ARA) - Buxar (BXR)", 589.0, 642.0)
                        ],
                        "tss": ["Danapur TSS", "Bihta TSS", "Ara TSS", "Buxar TSS"],
                        "fps": ["FP-DNR-01", "FP-BTA-02", "FP-ARA-01"],
                        "lines": ["UP Main Line", "DOWN Main Line"]
                    }
                ]
            },
            "DHN": {
                "name": "Dhanbad (DHN)",
                "sections": [
                    {
                        "section": "DHN - GMO - KQR",
                        "block_sections": [
                            ("Dhanbad (DHN) - Gomoh (GMO)", 270.0, 299.0),
                            ("Gomoh (GMO) - Parasnath (PNME)", 299.0, 318.0),
                            ("Parasnath (PNME) - Koderma (KQR)", 318.0, 388.0)
                        ],
                        "tss": ["Dhanbad TSS", "Gomoh TSS", "Koderma TSS"],
                        "fps": ["FP-DHN-01", "FP-GMO-01", "FP-KQR-02"],
                        "lines": ["UP Grand Chord", "DN Grand Chord", "Yard Line"]
                    }
                ]
            },
            "SPJ": {
                "name": "Samastipur (SPJ)",
                "sections": [
                    {
                        "section": "SPJ - MFP - HJP",
                        "block_sections": [
                            ("Samastipur (SPJ) - Muzaffarpur (MFP)", 50.0, 102.0),
                            ("Muzaffarpur (MFP) - Hajipur (HJP)", 102.0, 155.0)
                        ],
                        "tss": ["Samastipur TSS", "Muzaffarpur TSS", "Hajipur TSS"],
                        "fps": ["FP-SPJ-01", "FP-MFP-02"],
                        "lines": ["Single Line", "UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "SEE": {
                "name": "Sonpur (SEE)",
                "sections": [
                    {
                        "section": "SEE - CPR - SV",
                        "block_sections": [
                            ("Sonpur (SEE) - Chhapra (CPR)", 20.0, 75.0),
                            ("Chhapra (CPR) - Siwan (SV)", 75.0, 138.0)
                        ],
                        "tss": ["Sonpur TSS", "Chhapra TSS", "Siwan TSS"],
                        "fps": ["FP-SEE-01", "FP-CPR-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    },
    "ER": {
        "zone_name": "Eastern Railway",
        "divisions": {
            "ASN": {
                "name": "Asansol (ASN)",
                "sections": [
                    {
                        "section": "Andal - Sainthia",
                        "block_sections": [
                            ("Andal (UDL) - Ukhra (UKA)", 1.0, 5.0),
                            ("Ukhra (UKA) - Pandabeswar (PAW)", 5.0, 18.0),
                            ("Pandabeswar (PAW) - Dubrajpur (DUJ)", 18.0, 32.0),
                            ("Dubrajpur (DUJ) - Chhinpai (CPLE)", 32.0, 42.0),
                            ("Chhinpai (CPLE) - Siuri (SURI)", 42.0, 53.0),
                            ("Siuri (SURI) - Sainthia (SNT)", 53.0, 73.0)
                        ],
                        "tss": ["Ukhra TSS", "Siuri TSS", "Sainthia TSS"],
                        "fps": ["FP-03", "FP-06", "FP-10"],
                        "lines": ["Single Line", "UP Main Line", "DN Main Line"]
                    },
                    {
                        "section": "Asansol - Jasidih",
                        "block_sections": [
                            ("Asansol (ASN) - Sitarampur (STN)", 215.0, 224.0),
                            ("Sitarampur (STN) - Chittaranjan (CRJ)", 224.0, 239.0),
                            ("Chittaranjan (CRJ) - Madhupur (MDP)", 239.0, 294.0),
                            ("Madhupur (MDP) - Jasidih (JSME)", 294.0, 324.0),
                            ("Jasidih (JSME) - Deoghar (DGHR)", 324.0, 330.0)
                        ],
                        "tss": ["Asansol TSS", "Chittaranjan TSS", "Madhupur TSS", "Jasidih TSS"],
                        "fps": ["FP-ASN-01", "FP-CRJ-02", "FP-MDP-01", "FP-JSME-03"],
                        "lines": ["UP Main Line", "DN Main Line", "UP Loop Line", "DN Loop Line"]
                    }
                ]
            },
            "HWH": {
                "name": "Howrah (HWH)",
                "sections": [
                    {
                        "section": "Howrah - Barddhaman Main Line",
                        "block_sections": [
                            ("Howrah (HWH) - Bally (BLY)", 1.0, 10.0),
                            ("Bally (BLY) - Sheoraphuli (SHE)", 10.0, 22.5),
                            ("Sheoraphuli (SHE) - Bandel (BDC)", 22.5, 39.0),
                            ("Bandel (BDC) - Khanyan (KHN)", 39.0, 58.0),
                            ("Khanyan (KHN) - Memari (MYM)", 58.0, 82.0),
                            ("Memari (MYM) - Barddhaman (BWN)", 82.0, 107.0),
                            ("Barddhaman (BWN) - Khana (KAN)", 107.0, 120.0)
                        ],
                        "tss": ["Liluah TSS", "Bandel TSS", "Memari TSS", "Barddhaman TSS"],
                        "fps": ["FP-HWH-01", "FP-BDC-02", "FP-BWN-01"],
                        "lines": ["UP Main Line", "DN Main Line", "UP Chord Line", "DN Chord Line"]
                    },
                    {
                        "section": "Bandel - Rampurhat",
                        "block_sections": [
                            ("Sheoraphuli (SHE) - Tarakeswar (TAK)", 1.0, 35.0),
                            ("Khana (KAN) - Rampurhat (RPH)", 120.0, 208.0),
                            ("Rampurhat (RPH) - Azimganj (AZ)", 208.0, 260.0)
                        ],
                        "tss": ["Tarakeswar TSS", "Rampurhat TSS", "Azimganj TSS"],
                        "fps": ["FP-TAK-01", "FP-RPH-02", "FP-AZ-01"],
                        "lines": ["Single Line", "UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "SDAH": {
                "name": "Sealdah (SDAH)",
                "sections": [
                    {
                        "section": "Sealdah - Ranaghat",
                        "block_sections": [
                            ("Sealdah (SDAH) - Naihati (NH)", 0.0, 38.0),
                            ("Naihati (NH) - Ranaghat (RHA)", 38.0, 74.0)
                        ],
                        "tss": ["Naihati TSS", "Ranaghat TSS"],
                        "fps": ["FP-NH-01", "FP-RHA-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "MLDT": {
                "name": "Malda (MLDT)",
                "sections": [
                    {
                        "section": "Malda Town - Sahibganj",
                        "block_sections": [
                            ("Malda Town (MLDT) - New Farakka (NFK)", 340.0, 375.0),
                            ("New Farakka (NFK) - Barharwa (BHW)", 375.0, 395.0),
                            ("Barharwa (BHW) - Sahibganj (SBG)", 395.0, 445.0)
                        ],
                        "tss": ["New Farakka TSS", "Barharwa TSS", "Sahibganj TSS"],
                        "fps": ["FP-NFK-01", "FP-BHW-01", "FP-SBG-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    },
    "NR": {
        "zone_name": "Northern Railway",
        "divisions": {
            "UMB": {
                "name": "Ambala (UMB)",
                "sections": [
                    {
                        "section": "Ambala - Ludhiana Corridor",
                        "block_sections": [
                            ("Ambala Cantt (UMB) - Rajpura (RPJ)", 199.0, 227.0),
                            ("Rajpura (RPJ) - Sirhind (SIR)", 227.0, 252.0),
                            ("Sirhind (SIR) - Khanna (KNN)", 252.0, 270.0),
                            ("Khanna (KNN) - Doraha (DOA)", 270.0, 290.0),
                            ("Doraha (DOA) - Ludhiana (LDH)", 290.0, 312.0)
                        ],
                        "tss": ["Ambala TSS", "Rajpura TSS", "Sirhind TSS", "Ludhiana TSS"],
                        "fps": ["FP-UMB-01", "FP-RPJ-02", "FP-SIR-01", "FP-LDH-02"],
                        "lines": ["UP Main Line", "DOWN Main Line", "Yard Line"]
                    },
                    {
                        "section": "Ambala - Saharanpur - Kalka",
                        "block_sections": [
                            ("Ambala Cantt (UMB) - Jagadhri (JUDW)", 200.0, 248.0),
                            ("Jagadhri (JUDW) - Saharanpur (SRE)", 248.0, 281.0),
                            ("Ambala Cantt (UMB) - Chandigarh (CDG)", 200.0, 245.0),
                            ("Chandigarh (CDG) - Kalka (KLK)", 245.0, 268.0),
                            ("Kurukshetra (KKDE) - Dhuri (DUI)", 160.0, 260.0),
                            ("Dhuri (DUI) - Bathinda (BTI)", 260.0, 350.0)
                        ],
                        "tss": ["Saharanpur TSS", "Chandigarh TSS", "Dhuri TSS", "Bathinda TSS"],
                        "fps": ["FP-SRE-01", "FP-CDG-02", "FP-DUI-01"],
                        "lines": ["Single Line", "UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "DLI": {
                "name": "Delhi (DLI)",
                "sections": [
                    {
                        "section": "Delhi - Ghaziabad - Panipat",
                        "block_sections": [
                            ("New Delhi (NDLS) - Ghaziabad (GZB)", 0.0, 25.0),
                            ("Delhi (DLI) - Panipat (PNP)", 0.0, 89.0)
                        ],
                        "tss": ["Sahibabad TSS", "Panipat TSS"],
                        "fps": ["FP-GZB-01", "FP-PNP-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "LKO": {
                "name": "Lucknow (LKO)",
                "sections": [
                    {
                        "section": "Lucknow - Rae Bareli - Varanasi",
                        "block_sections": [
                            ("Lucknow (LKO) - Rae Bareli (RBL)", 0.0, 78.0),
                            ("Rae Bareli (RBL) - Pratapgarh (PBH)", 78.0, 172.0)
                        ],
                        "tss": ["Rae Bareli TSS", "Pratapgarh TSS"],
                        "fps": ["FP-RBL-01", "FP-PBH-01"],
                        "lines": ["Single Line", "UP Main Line"]
                    }
                ]
            },
            "MB": {
                "name": "Moradabad (MB)",
                "sections": [
                    {
                        "section": "Moradabad - Bareilly",
                        "block_sections": [
                            ("Moradabad (MB) - Rampur (RMU)", 0.0, 27.0),
                            ("Rampur (RMU) - Bareilly (BE)", 27.0, 90.0)
                        ],
                        "tss": ["Rampur TSS", "Bareilly TSS"],
                        "fps": ["FP-RMU-01", "FP-BE-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "FZR": {
                "name": "Firozpur (FZR)",
                "sections": [
                    {
                        "section": "Jalandhar - Amritsar",
                        "block_sections": [
                            ("Jalandhar City (JUC) - Beas (BEAS)", 0.0, 43.0),
                            ("Beas (BEAS) - Amritsar (ASR)", 43.0, 79.0)
                        ],
                        "tss": ["Beas TSS", "Amritsar TSS"],
                        "fps": ["FP-BEAS-01", "FP-ASR-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    },
    "CR": {
        "zone_name": "Central Railway",
        "divisions": {
            "CSMT": {
                "name": "Mumbai (CSMT)",
                "sections": [
                    {
                        "section": "CSMT - Kalyan - Kasara / Karjat",
                        "block_sections": [
                            ("CSMT - Thane (TNA)", 0.0, 34.0),
                            ("Thane (TNA) - Kalyan (KYN)", 34.0, 54.0),
                            ("Kalyan (KYN) - Kasara (KSRA)", 54.0, 120.0),
                            ("Kalyan (KYN) - Karjat (KJT)", 54.0, 100.0)
                        ],
                        "tss": ["Kalyan TSS", "Kasara TSS", "Karjat TSS"],
                        "fps": ["FP-KYN-01", "FP-KJT-02"],
                        "lines": ["UP Suburban", "DN Suburban", "UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "BSL": {
                "name": "Bhusawal (BSL)",
                "sections": [
                    {
                        "section": "Igatpuri - Bhusawal - Akola",
                        "block_sections": [
                            ("Igatpuri (IGP) - Manmad (MMR)", 137.0, 261.0),
                            ("Manmad (MMR) - Bhusawal (BSL)", 261.0, 444.0)
                        ],
                        "tss": ["Manmad TSS", "Bhusawal TSS"],
                        "fps": ["FP-MMR-01", "FP-BSL-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "PUNE": {
                "name": "Pune (PUNE)",
                "sections": [
                    {
                        "section": "Lonavala - Pune - Daund",
                        "block_sections": [
                            ("Lonavala (LNL) - Pune (PUNE)", 128.0, 192.0),
                            ("Pune (PUNE) - Daund (DD)", 192.0, 268.0)
                        ],
                        "tss": ["Pune TSS", "Daund TSS"],
                        "fps": ["FP-PUNE-01", "FP-DD-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "SUR": {
                "name": "Solapur (SUR)",
                "sections": [
                    {
                        "section": "Daund - Solapur - Wadi",
                        "block_sections": [
                            ("Daund (DD) - Kurduvadi (KWV)", 0.0, 78.0),
                            ("Kurduvadi (KWV) - Solapur (SUR)", 78.0, 156.0)
                        ],
                        "tss": ["Kurduvadi TSS", "Solapur TSS"],
                        "fps": ["FP-KWV-01", "FP-SUR-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "NGP": {
                "name": "Nagpur (NGP)",
                "sections": [
                    {
                        "section": "Badnera - Wardha - Nagpur",
                        "block_sections": [
                            ("Badnera (BD) - Wardha (WR)", 0.0, 95.0),
                            ("Wardha (WR) - Nagpur (NGP)", 95.0, 174.0)
                        ],
                        "tss": ["Wardha TSS", "Nagpur TSS"],
                        "fps": ["FP-WR-01", "FP-NGP-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    },
    "WR": {
        "zone_name": "Western Railway",
        "divisions": {
            "MMCT": {
                "name": "Mumbai Central (MMCT)",
                "sections": [
                    {
                        "section": "Churchgate - Virar - Dahanu",
                        "block_sections": [
                            ("Churchgate (CCG) - Borivali (BVI)", 0.0, 34.0),
                            ("Borivali (BVI) - Virar (VR)", 34.0, 60.0),
                            ("Virar (VR) - Dahanu Road (DRD)", 60.0, 124.0)
                        ],
                        "tss": ["Bandra TSS", "Virar TSS", "Palghar TSS"],
                        "fps": ["FP-BVI-01", "FP-VR-01"],
                        "lines": ["UP Fast", "DN Fast", "UP Slow", "DN Slow"]
                    }
                ]
            },
            "BRC": {
                "name": "Vadodara (BRC)",
                "sections": [
                    {
                        "section": "Surat - Vadodara - Anand",
                        "block_sections": [
                            ("Surat (ST) - Bharuch (BH)", 263.0, 322.0),
                            ("Bharuch (BH) - Vadodara (BRC)", 322.0, 392.0)
                        ],
                        "tss": ["Bharuch TSS", "Vadodara TSS"],
                        "fps": ["FP-BH-01", "FP-BRC-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "ADI": {
                "name": "Ahmedabad (ADI)",
                "sections": [
                    {
                        "section": "Vadodara - Ahmedabad - Mehsana",
                        "block_sections": [
                            ("Anand (ANND) - Ahmedabad (ADI)", 35.0, 100.0),
                            ("Ahmedabad (ADI) - Mehsana (MSH)", 100.0, 170.0)
                        ],
                        "tss": ["Ahmedabad TSS", "Mehsana TSS"],
                        "fps": ["FP-ADI-01", "FP-MSH-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "RTM": {
                "name": "Ratlam (RTM)",
                "sections": [
                    {
                        "section": "Godhra - Ratlam - Nagda",
                        "block_sections": [
                            ("Godhra (GDA) - Dahod (DHD)", 460.0, 534.0),
                            ("Dahod (DHD) - Ratlam (RTM)", 534.0, 648.0)
                        ],
                        "tss": ["Dahod TSS", "Ratlam TSS"],
                        "fps": ["FP-DHD-01", "FP-RTM-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "RJT": {
                "name": "Rajkot (RJT)",
                "sections": [
                    {
                        "section": "Surendranagar - Rajkot - Wankaner",
                        "block_sections": [
                            ("Surendranagar (SUNR) - Wankaner (WKR)", 0.0, 74.0),
                            ("Wankaner (WKR) - Rajkot (RJT)", 74.0, 116.0)
                        ],
                        "tss": ["Wankaner TSS", "Rajkot TSS"],
                        "fps": ["FP-WKR-01", "FP-RJT-01"],
                        "lines": ["Single Line", "UP Main Line"]
                    }
                ]
            }
        }
    },
    "NCR": {
        "zone_name": "North Central Railway",
        "divisions": {
            "PRYJ": {
                "name": "Prayagraj (PRYJ)",
                "sections": [
                    {
                        "section": "DDU - Mirzapur - Prayagraj - Kanpur",
                        "block_sections": [
                            ("Pt. Deen Dayal Upadhyaya (DDU) - Mirzapur (MZP)", 0.0, 63.0),
                            ("Mirzapur (MZP) - Prayagraj (PRYJ)", 63.0, 153.0),
                            ("Prayagraj (PRYJ) - Fatehpur (FTP)", 153.0, 270.0),
                            ("Fatehpur (FTP) - Kanpur Central (CNB)", 270.0, 348.0)
                        ],
                        "tss": ["Mirzapur TSS", "Naini TSS", "Fatehpur TSS", "Kanpur TSS"],
                        "fps": ["FP-MZP-01", "FP-PRYJ-01", "FP-CNB-01"],
                        "lines": ["UP Main Line", "DN Main Line", "3rd Line"]
                    }
                ]
            },
            "AGC": {
                "name": "Agra (AGC)",
                "sections": [
                    {
                        "section": "Palwal - Mathura - Agra Cantt",
                        "block_sections": [
                            ("Mathura (MTJ) - Agra Cantt (AGC)", 140.0, 194.0),
                            ("Agra Cantt (AGC) - Dholpur (DHO)", 194.0, 246.0)
                        ],
                        "tss": ["Mathura TSS", "Agra TSS"],
                        "fps": ["FP-MTJ-01", "FP-AGC-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "JHS": {
                "name": "Jhansi (JHS)",
                "sections": [
                    {
                        "section": "Gwalior - Jhansi - Lalitpur - Bina",
                        "block_sections": [
                            ("Gwalior (GWL) - Jhansi (VGLJ)", 314.0, 411.0),
                            ("Jhansi (VGLJ) - Bina (BINA)", 411.0, 564.0)
                        ],
                        "tss": ["Gwalior TSS", "Jhansi TSS", "Bina TSS"],
                        "fps": ["FP-GWL-01", "FP-JHS-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    },
    "SCR": {
        "zone_name": "South Central Railway",
        "divisions": {
            "SC": {
                "name": "Secunderabad (SC)",
                "sections": [
                    {
                        "section": "Kazipet - Secunderabad - Wadi",
                        "block_sections": [
                            ("Kazipet (KZJ) - Moula Ali (MLY)", 0.0, 126.0),
                            ("Secunderabad (SC) - Vikarabad (VKB)", 0.0, 72.0)
                        ],
                        "tss": ["Kazipet TSS", "Secunderabad TSS"],
                        "fps": ["FP-KZJ-01", "FP-SC-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "BZA": {
                "name": "Vijayawada (BZA)",
                "sections": [
                    {
                        "section": "Gudur - Vijayawada - Rajahmundry",
                        "block_sections": [
                            ("Ongole (OGL) - Tenali (TEL)", 290.0, 396.0),
                            ("Tenali (TEL) - Vijayawada (BZA)", 396.0, 427.0)
                        ],
                        "tss": ["Tenali TSS", "Vijayawada TSS"],
                        "fps": ["FP-TEL-01", "FP-BZA-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    },
    "SR": {
        "zone_name": "Southern Railway",
        "divisions": {
            "MAS": {
                "name": "Chennai (MAS)",
                "sections": [
                    {
                        "section": "Chennai - Arakkonam - Katpadi",
                        "block_sections": [
                            ("Chennai Central (MAS) - Arakkonam (AJJ)", 0.0, 69.0),
                            ("Arakkonam (AJJ) - Katpadi (KPD)", 69.0, 130.0)
                        ],
                        "tss": ["Avadi TSS", "Arakkonam TSS", "Katpadi TSS"],
                        "fps": ["FP-AJJ-01", "FP-KPD-01"],
                        "lines": ["UP Fast", "DN Fast", "UP Main", "DN Main"]
                    }
                ]
            }
        }
    },
    "SER": {
        "zone_name": "South Eastern Railway",
        "divisions": {
            "KGP": {
                "name": "Kharagpur (KGP)",
                "sections": [
                    {
                        "section": "Howrah - Kharagpur - Tatanagar",
                        "block_sections": [
                            ("Panskura (PKU) - Kharagpur (KGP)", 71.0, 115.0),
                            ("Kharagpur (KGP) - Jhargram (JGM)", 115.0, 154.0),
                            ("Jhargram (JGM) - Tatanagar (TATA)", 154.0, 250.0)
                        ],
                        "tss": ["Kharagpur TSS", "Jhargram TSS", "Ghatsila TSS"],
                        "fps": ["FP-KGP-01", "FP-JGM-01"],
                        "lines": ["UP Main Line", "DN Main Line", "3rd Line"]
                    }
                ]
            }
        }
    },
    "WCR": {
        "zone_name": "West Central Railway",
        "divisions": {
            "KOTA": {
                "name": "Kota (KOTA)",
                "sections": [
                    {
                        "section": "Nagda - Kota - Sawai Madhopur",
                        "block_sections": [
                            ("Shamgarh (SGZ) - Ramganj Mandi (RMA)", 710.0, 772.0),
                            ("Ramganj Mandi (RMA) - Kota (KOTA)", 772.0, 845.0)
                        ],
                        "tss": ["Ramganj Mandi TSS", "Kota TSS"],
                        "fps": ["FP-RMA-01", "FP-KOTA-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            },
            "JBP": {
                "name": "Jabalpur (JBP)",
                "sections": [
                    {
                        "section": "Itarsi - Jabalpur - Katni",
                        "block_sections": [
                            ("Pipariya (PPI) - Narsinghpur (NU)", 68.0, 160.0),
                            ("Narsinghpur (NU) - Jabalpur (JBP)", 160.0, 245.0)
                        ],
                        "tss": ["Pipariya TSS", "Jabalpur TSS"],
                        "fps": ["FP-NU-01", "FP-JBP-01"],
                        "lines": ["UP Main Line", "DN Main Line"]
                    }
                ]
            }
        }
    }
}

# Seasonal TDMS activities mapped to months
SEASONAL_ACTIVITIES = {
    # September - October: Post-monsoon
    (9, 10): [
        ("Post-monsoon OHE condition inspection & drainage clearing", "Preventive OHE inspection", 120),
        ("Water ingress check at feeder posts and gantries", "Feeding-post maintenance", 150),
        ("Corrosion detection on OHE masts and portal structures", "OHE mast and portal inspection", 180),
        ("Insulator mud and contaminant cleaning after heavy rains", "Preventive OHE inspection", 120),
        ("Vegetation trimming along trackside 25kV feeder lines", "Preventive OHE inspection", 90),
        ("Substation drainage and oil sump water evacuation", "Traction substation maintenance", 180),
        ("Flashover mark inspection on porcelain & composite insulators", "Section-insulator inspection", 120),
        ("Earthing and bonding resistance check after monsoon saturation", "Earthing and bonding maintenance", 150),
    ],
    # November - December: Preventive maintenance & winter prep
    (11, 12): [
        ("Preventive OHE inspection & cantilever bracket adjustment", "Preventive OHE inspection", 150),
        ("Isolator contact cleaning, greasing and alignment servicing", "Isolator maintenance", 120),
        ("Contact-wire thickness ultrasonic measurement and profiling", "Contact-wire inspection", 150),
        ("Dropper renewal and loop replacement over UP/DN track", "Dropper renewal", 180),
        ("Section insulator overhaul and PTFE neutral section inspection", "Section-insulator inspection", 150),
        ("Cantilever assembly AOH and steady arm tension check", "Preventive OHE inspection", 120),
        ("Auto-Tensioning Device (ATD) weight check & anti-creep survey", "Preventive OHE inspection", 120),
        ("Traction substation vacuum circuit breaker (VCB) timing test", "Circuit-breaker testing", 210),
        ("SCADA RTU communication and tele-command verification", "SCADA/RTU maintenance", 120),
        ("Station yard OHE registration and turn-out cross-over check", "Contact-wire inspection", 150),
        ("Mast earthing and cross-track bonding continuity testing", "Earthing and bonding maintenance", 120)
    ],
    # January: Fog-season & winter reliability
    (1,): [
        ("Fog-season OHE visibility & insulator anti-pollution silicone coating", "Preventive OHE inspection", 180),
        ("Winter equipment reliability checks and thermal imaging of jumpers", "Preventive OHE inspection", 120),
        ("Cold-weather ATD compensation and tension-length measurement", "Catenary inspection", 150),
        ("Battery bank discharge capacity testing and electrolyte topping", "Battery and DC system maintenance", 120),
        ("Emergency preparedness inspection of breakdown tower wagon RU", "Preventive OHE inspection", 90),
        ("Isolator mechanical link de-icing and greasing check", "Isolator maintenance", 120),
        ("Contact wire tension monitoring under winter thermal contraction", "Contact-wire inspection", 150),
        ("Booster transformer and return conductor jumper inspection", "Feeding-post maintenance", 150),
        ("Emergency OHE restoration readiness test and clamp renewal", "Emergency OHE repair", 180)
    ],
    # February - March: Planned annual maintenance & renewals
    (2, 3): [
        ("Annual overhauling (AOH) of catenary and contact wire system", "Preventive OHE inspection", 240),
        ("Major contact wire replacement for worn spans (>3.5mm wear)", "Contact-wire replacement", 300),
        ("Catenary wire renewal and tension balance adjustment", "Catenary replacement", 360),
        ("Complete dropper renewal batch replacement using 8W tower wagon", "Dropper renewal", 210),
        ("Traction substation power transformer (25kV) annual testing", "Traction substation maintenance", 360),
        ("Feeding post 25kV isolator motor-drive mechanism replacement", "Isolator maintenance", 180),
        ("Section insulator replacement with lightweight PTFE assembly", "Section-insulator replacement", 240),
        ("Portal bolt tightening, gantry painting and anti-corrosion treat", "OHE mast and portal inspection", 240),
        ("Relay protection panel calibration and distance relay testing", "Traction substation maintenance", 210),
        ("Capacitor bank and harmonic filter circuit breaker overhaul", "Circuit-breaker testing", 240),
        ("SCADA remote tele-metering calibration and battery charger replacement", "SCADA/RTU maintenance", 180),
        ("Earth mat resistance measurement and earth electrode re-boring", "Earthing and bonding maintenance", 180)
    ]
}

REQUISITION_TYPES_DIST = [
    ("Power Block & Traffic Block", 0.40),
    ("Power Block Only", 0.20),
    ("Traffic Block Only", 0.15),
    ("Electrical Isolation Request", 0.10),
    ("Emergency Power Shutdown", 0.05),
    ("OHE Maintenance Block", 0.05),
    ("Traction Substation Shutdown", 0.05)
]

PRIORITY_DIST = [
    ("LOW", 0.20),
    ("MEDIUM", 0.40),
    ("HIGH", 0.30),
    ("CRITICAL", 0.10)
]

EQUIPMENT_LIST = [
    ("4-Wheeler OHE Tower Wagon", "TW-4W"),
    ("8-Wheeler OHE Tower Wagon", "TW-8W"),
    ("Ladder Trolley Batch", "LT-BAT"),
    ("OHE Inspection Car (NETRA-TRD)", "NETRA"),
    ("Hydraulic Crimping & Tensioning Machine", "HCT"),
    ("Portable Earthing Equipment & Discharge Rods", "PE-DIS"),
    ("Contact-Wire Laser Measuring Device", "CLMD"),
    ("High-Voltage 50kV Insulation Resistance Tester", "HV-IRT"),
    ("Earth Resistance Megger Kit", "ER-MEG"),
    ("Rail/OHE Elevated Access Platform Car", "EAP-RU")
]

SUPERVISOR_DESIGNATIONS = [
    "SSE_TRD", "SSE_OHE", "SSE_TRACTION", "SSE_TRD_SUB_DIV",
    "JE_TRD", "JE_OHE", "JE_TRACTION", "TRD Inspector",
    "ADEE_TRD", "DEE_TRD", "Tower Wagon Operator (Special)",
    "Senior Section Engineer (TRD / OHE)"
]

def get_activity_for_date(target_date: date):
    m = target_date.month
    for months, activities in SEASONAL_ACTIVITIES.items():
        if m in months:
            return random.choice(activities)
    # Default fallback
    return random.choice(SEASONAL_ACTIVITIES[(11, 12)])

def generate_supervisor(division_code: str):
    emp_id = f"TRD{random.randint(900001, 999999)}"
    desig = random.choice(SUPERVISOR_DESIGNATIONS)
    # Masked mobile number
    patterns = [
        f"97714{random.randint(10000, 99999)}",
        f"98{random.randint(1000, 9999)}XX{random.randint(10, 99)}",
        f"9431{random.randint(100000, 999999)}"
    ]
    mobile = random.choice(patterns)
    return {
        "emp_id": emp_id,
        "designation": desig,
        "mobile": mobile
    }

def generate_synthetic_record(record_idx: int, existing_ids: set, target_date: date, zone_key: str = None):
    # Select Zone and Division
    # Weight priority zones higher (ECR, ER, NR)
    if not zone_key:
        zone_weights = {
            "ECR": 0.30, # East Central (DDU priority)
            "ER":  0.25, # Eastern (Asansol, Howrah priority)
            "NR":  0.15, # Northern (Ambala priority)
            "CR":  0.06,
            "WR":  0.06,
            "NCR": 0.06,
            "SCR": 0.04,
            "SR":  0.03,
            "SER": 0.03,
            "WCR": 0.02
        }
        zones = list(zone_weights.keys())
        probs = list(zone_weights.values())
        zone_key = np.random.choice(zones, p=probs)
    
    zone_data = RAILWAY_MASTER[zone_key]
    zone_name = zone_data["zone_name"]
    
    # Select division
    div_keys = list(zone_data["divisions"].keys())
    if zone_key == "ECR" and "DDU" in div_keys:
        # Give DDU 70% of ECR
        div_weights = [0.70 if k == "DDU" else 0.30 / (len(div_keys) - 1) for k in div_keys]
        div_key = np.random.choice(div_keys, p=div_weights)
    elif zone_key == "ER":
        # ASN 45%, HWH 35%, others 20%
        div_weights = []
        for k in div_keys:
            if k == "ASN": div_weights.append(0.45)
            elif k == "HWH": div_weights.append(0.35)
            else: div_weights.append(0.20 / (len(div_keys) - 2))
        div_key = np.random.choice(div_keys, p=div_weights)
    elif zone_key == "NR":
        # UMB 50%
        div_weights = [0.50 if k == "UMB" else 0.50 / (len(div_keys) - 1) for k in div_keys]
        div_key = np.random.choice(div_keys, p=div_weights)
    else:
        div_key = random.choice(div_keys)
        
    div_data = zone_data["divisions"][div_key]
    div_name = div_data["name"]
    
    # Section details
    section_choice = random.choice(div_data["sections"])
    sec_name = section_choice["section"]
    bs_name, km_min, km_max = random.choice(section_choice["block_sections"])
    line_name = random.choice(section_choice["lines"])
    tss_name = random.choice(section_choice["tss"])
    fp_name = random.choice(section_choice["fps"])
    
    # Elementary section number
    es_num = f"ES-{zone_key}-{div_key}-{random.randint(10, 99)}"
    
    # Physical track boundaries (km and masts)
    from_km = round(random.uniform(km_min, max(km_min + 0.1, km_max - 2.5)), 3)
    span_len = round(random.uniform(0.400, 3.800), 3)
    to_km = round(from_km + span_len, 3)
    
    mast_km_int = int(from_km)
    from_mast_num = f"{mast_km_int:03d}/{random.randint(1, 20):02d}"
    to_mast_km_int = int(to_km)
    to_mast_num = f"{to_mast_km_int:03d}/{random.randint(21, 38):02d}"
    
    # Activity and nature of work
    work_title, activity_cat, base_duration = get_activity_for_date(target_date)
    duration_min = int(max(60, min(480, np.random.normal(base_duration, 25))))
    duration_min = (duration_min // 15) * 15 # Round to 15 min intervals
    
    # Requisition Type
    req_types, req_probs = zip(*REQUISITION_TYPES_DIST)
    # If nature of work is Major contact replacement, force Power Block & Traffic Block
    if "replacement" in work_title.lower() or "renewal" in work_title.lower():
        req_type = "Power Block & Traffic Block"
    elif "substation" in work_title.lower() or "transformer" in work_title.lower():
        req_type = random.choice(["Traction Substation Shutdown", "Power Block Only"])
    elif "scada" in work_title.lower() or "earthing" in work_title.lower():
        req_type = random.choice(["Power Block Only", "Electrical Isolation Request", "Traffic Block Only"])
    else:
        req_type = np.random.choice(req_types, p=req_probs)
        
    # Block requirements and operational impact
    requires_power_block = req_type in [
        "Power Block & Traffic Block", "Power Block Only", "Emergency Power Shutdown",
        "OHE Maintenance Block", "Traction Substation Shutdown", "Electrical Isolation Request"
    ]
    requires_traffic_block = req_type in [
        "Power Block & Traffic Block", "Traffic Block Only", "OHE Maintenance Block"
    ]
    electric_traction_dead = requires_power_block
    power_cutoff_voltage = "25 kV AC" if requires_power_block else "Not Required"
    diesel_loco_movement_permissible = not ("emergency" in req_type.lower() and random.random() < 0.3)
    adjacent_line_restricted = random.random() < 0.25 if requires_traffic_block else False
    neutral_section_affected = random.random() < 0.15
    alternate_feeding_available = random.random() < 0.65
    
    # Preferred window (start and end times)
    start_hour = random.choice([8, 9, 10, 11, 12, 13, 14, 15, 16, 22, 23])
    start_minute = random.choice([0, 15, 30, 45])
    start_dt = datetime.combine(target_date, datetime.min.time()).replace(hour=start_hour, minute=start_minute)
    end_dt = start_dt + timedelta(minutes=duration_min)
    
    start_time_str = start_dt.strftime("%H:%M:%S")
    end_time_str = end_dt.strftime("%H:%M:%S")
    start_time_short = start_dt.strftime("%H:%M")
    end_time_short = end_dt.strftime("%H:%M")
    
    # Equipment
    equip_name, equip_code = random.choice(EQUIPMENT_LIST)
    eq_id = f"RU-{random.randint(8100, 9999)}" if "Tower Wagon" in equip_name else f"EQ-{zone_key}-{div_key}-{random.randint(100, 999)}"
    deployed_text = f"{equip_name} ({eq_id})"
    
    tower_movement = f"Requires path into block section from nearest yard ({bs_name.split('-')[0].strip()})" if "Tower Wagon" in equip_name else "Road / Off-track movement"
    
    # Isolators to open
    iso_count = random.randint(1, 3)
    isolators = [f"ISO-{zone_key}-{div_key}-{random.randint(100, 499)}-{i}" for i in range(1, iso_count + 1)]
    
    # Priority
    prios, prio_probs = zip(*PRIORITY_DIST)
    if "emergency" in req_type.lower() or "Major contact" in work_title:
        priority = random.choice(["HIGH", "CRITICAL"])
    else:
        priority = np.random.choice(prios, p=prio_probs)
        
    # Cost and Downtime estimation based on rules in prompt
    cost_ranges = {
        "Preventive OHE inspection": (3000, 18000),
        "Contact-wire inspection": (4000, 20000),
        "Catenary inspection": (5000, 25000),
        "Dropper renewal": (8000, 35000),
        "Contact-wire replacement": (35000, 150000),
        "Catenary replacement": (40000, 180000),
        "Section-insulator inspection": (15000, 60000),
        "Section-insulator replacement": (25000, 100000),
        "Isolator maintenance": (5000, 35000),
        "OHE mast and portal inspection": (15000, 100000),
        "Earthing and bonding maintenance": (8000, 45000),
        "Traction substation maintenance": (50000, 450000),
        "Feeding-post maintenance": (20000, 120000),
        "Circuit-breaker testing": (25000, 200000),
        "SCADA/RTU maintenance": (10000, 120000),
        "Battery and DC system maintenance": (25000, 180000),
        "Emergency OHE repair": (40000, 300000)
    }
    c_min, c_max = cost_ranges.get(activity_cat, (10000, 50000))
    est_cost = int(round(random.uniform(c_min, c_max), -2))
    
    # Machine Learning and Condition Indicators
    asset_age_years = round(random.uniform(1.5, 32.0), 1)
    days_since_maint = random.randint(15, 365)
    last_maint_date = (target_date - timedelta(days=days_since_maint)).isoformat()
    next_due_date = (target_date + timedelta(days=random.randint(30, 180))).isoformat()
    
    # Wear increases with age and traffic
    base_wear = 0.5 + (asset_age_years / 32.0) * 2.8 + random.uniform(-0.3, 0.5)
    contact_wire_wear = round(max(0.2, min(4.6, base_wear)), 2)
    
    catenary_tension = round(random.uniform(9.6, 10.8), 2)
    ohe_height = int(random.gauss(5500, 60))
    ohe_stagger = int(random.gauss(0, 80))
    
    insulation_res = round(random.uniform(150.0, 1800.0), 1)
    earth_res = round(random.uniform(0.8, 6.5), 2)
    iso_ops = random.randint(50, 950)
    cb_ops = random.randint(100, 2800)
    feeder_load = round(random.uniform(42.0, 92.0), 1)
    peak_current = round(random.uniform(250.0, 850.0), 1)
    xfmr_temp = round(random.uniform(42.0, 78.0), 1)
    battery_volt = round(random.uniform(109.0, 116.5), 1)
    battery_health = round(random.uniform(72.0, 99.0), 1)
    scada_uptime = round(random.uniform(96.5, 99.9), 2)
    fault_count_90 = random.choices([0, 1, 2, 3, 4], weights=[0.55, 0.25, 0.12, 0.05, 0.03])[0]
    
    # Seasonal climate factors
    if target_date.month in [9, 10]:
        rainfall_mm = round(random.uniform(15.0, 180.0), 1)
        humidity = round(random.uniform(70.0, 95.0), 1)
        temp_c = round(random.uniform(26.0, 34.0), 1)
    elif target_date.month in [11, 12, 1]:
        rainfall_mm = round(random.uniform(0.0, 15.0), 1)
        humidity = round(random.uniform(45.0, 85.0), 1)
        temp_c = round(random.uniform(8.0, 22.0), 1)
    else:
        rainfall_mm = round(random.uniform(0.0, 25.0), 1)
        humidity = round(random.uniform(35.0, 65.0), 1)
        temp_c = round(random.uniform(20.0, 36.0), 1)
        
    # Failure probability and risk score calculation
    condition_penalty = (contact_wire_wear / 4.0) * 0.35 + (days_since_maint / 365.0) * 0.25 + (fault_count_90 / 4.0) * 0.25 + (asset_age_years / 35.0) * 0.15
    noise = random.uniform(-0.08, 0.08)
    risk_score = round(max(0.05, min(0.98, condition_penalty + noise)), 2)
    failure_prob = round(max(0.02, min(0.95, risk_score * 0.92 + random.uniform(-0.05, 0.05))), 2)
    
    failure_occurred = failure_prob > 0.75 and random.random() < 0.40
    failure_type = None
    if failure_occurred:
        failure_types = [
            "Contact Wire Parting", "Dropper Snapping", "Isolator Flashover",
            "Insulator Puncture", "TSS Feeder Trip", "Bird Caging of Catenary",
            "ATD Jamming", "Neutral Section Flashover"
        ]
        failure_type = random.choice(failure_types)
        
    # Requisition ID: format TDMS/{ZONE_CODE}/{DIVISION_CODE}/{YEAR}/PB/{SEQUENCE:04d}
    year_str = str(target_date.year)
    seq_num = 1000 + record_idx
    req_id = f"TDMS/{zone_key}/{div_key}/{year_str}/PB/{seq_num:04d}"
    while req_id in existing_ids:
        seq_num += 1
        req_id = f"TDMS/{zone_key}/{div_key}/{year_str}/PB/{seq_num:04d}"
    existing_ids.add(req_id)
    
    # Supervisor
    supervisor = generate_supervisor(div_key)
    
    # Full nested payload matching hybrid schema
    payload = {
        "source_system": "TDMS_ELECTRICAL_TRD",
        "requisition_id": req_id,
        "requisition_type": req_type,
        "supervisor_details": supervisor,
        "electrical_section_details": {
            "zone": zone_name,
            "zone_code": zone_key,
            "division": div_name,
            "division_code": div_key,
            "traction_sub_station": tss_name,
            "feeding_post": fp_name,
            "elementary_section_no": es_num,
            "isolators_to_open": isolators,
            "neutral_section_affected": neutral_section_affected
        },
        "physical_track_boundaries": {
            "section": sec_name,
            "block_section": bs_name,
            "line": line_name,
            "from_ohe_mast": from_mast_num,
            "to_ohe_mast": to_mast_num,
            "from_chainage_km": str(from_km),
            "to_chainage_km": str(to_km)
        },
        "work_specifications": {
            "nature_of_work": work_title,
            "equipment_deployed": deployed_text,
            "equipment_id": eq_id,
            "tower_wagon_movement": tower_movement,
            "duration_minutes": duration_min,
            "preferred_window": {
                "date": target_date.isoformat(),
                "start_time": start_time_short,
                "end_time": end_time_short
            }
        },
        "operational_impact": {
            "power_cutoff_voltage": power_cutoff_voltage,
            "electric_traction_dead": electric_traction_dead,
            "diesel_loco_movement_permissible": diesel_loco_movement_permissible,
            "adjacent_line_restricted": adjacent_line_restricted,
            "alternate_feeding_available": alternate_feeding_available
        },
        "safety_protocols": {
            "requires_power_block": requires_power_block,
            "requires_traffic_block": requires_traffic_block,
            "power_isolation_confirmed": False,
            "discharge_rod_applied": False,
            "temporary_earthing_provided": False,
            "permit_to_work_issued": False,
            "line_clear_obtained": False,
            "tower_wagon_brakes_checked": "Tower Wagon" in equip_name,
            "staff_protection_confirmed": False,
            "adjacent_line_protection_provided": False,
            "equipment_deenergized": False,
            "restoration_checklist_required": True
        },
        "maintenance_metadata": {
            "priority": priority,
            "work_status": "Planned",
            "maintenance_category": activity_cat,
            "estimated_cost_inr": est_cost,
            "estimated_downtime_minutes": duration_min,
            "risk_score": risk_score,
            "failure_probability": failure_prob,
            "failure_occurred": failure_occurred,
            "failure_type": failure_type,
            "synthetic_record": True,
            "asset_age_years": asset_age_years,
            "last_maintenance_date": last_maint_date,
            "next_due_date": next_due_date,
            "days_since_last_maintenance": days_since_maint,
            "contact_wire_wear_mm": contact_wire_wear,
            "catenary_tension_kn": catenary_tension,
            "OHE_height_mm": ohe_height,
            "OHE_stagger_mm": ohe_stagger,
            "insulation_resistance_megaohm": insulation_res,
            "earth_resistance_ohm": earth_res,
            "isolator_operation_count": iso_ops,
            "circuit_breaker_operation_count": cb_ops,
            "feeder_load_percent": feeder_load,
            "peak_current_ampere": peak_current,
            "transformer_temperature_celsius": xfmr_temp,
            "battery_voltage": battery_volt,
            "battery_health_percent": battery_health,
            "SCADA_uptime_percent": scada_uptime,
            "fault_count_last_90_days": fault_count_90,
            "rainfall_mm": rainfall_mm,
            "humidity_percent": humidity,
            "temperature_celsius": temp_c
        }
    }
    
    # Flattened table row record for `tdms_requisitions`
    row_record = {
        "requisition_id": req_id,
        "source_system": "TDMS_ELECTRICAL_TRD",
        "requisition_type": req_type,
        "zone": zone_name.upper(), # Matches DB convention 'EASTERN RAILWAY'
        "division": div_name,
        "section": sec_name,
        "block_section": bs_name,
        "line_name": line_name,
        "traction_sub_station": tss_name,
        "elementary_section_no": es_num,
        "preferred_date": target_date,
        "start_time": start_time_str,
        "end_time": end_time_str,
        "duration_minutes": duration_min,
        "nature_of_work": work_title,
        "equipment_deployed": deployed_text,
        "payload": payload
    }
    
    return row_record

def generate_tdms_dataset(num_records: int = 2600, existing_ids: set = None):
    if existing_ids is None:
        existing_ids = set()
        
    start_date = date(2026, 9, 15)
    end_date = date(2027, 3, 15)
    total_days = (end_date - start_date).days
    
    dataset = []
    print(f"Generating {num_records} synthetic TDMS records from {start_date} to {end_date}...")
    
    for i in range(num_records):
        # Distribute dates realistically across the 181 days
        day_offset = int(np.random.uniform(0, total_days))
        rec_date = start_date + timedelta(days=day_offset)
        record = generate_synthetic_record(i + 1, existing_ids, rec_date)
        dataset.append(record)
        
    print(f"Successfully generated {len(dataset)} TDMS records.")
    return dataset

if __name__ == "__main__":
    records = generate_tdms_dataset(10)
    import json
    print("\nSample Generated Record:")
    print(json.dumps(records[0]["payload"], indent=2, default=str))
