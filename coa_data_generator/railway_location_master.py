"""
Railway Location Master for COA Master Timetable Generator.
Covers comprehensive Indian Railways Zones, Divisions, Sub-Divisions, Sections,
Stations, CSR, and Track Lines with priority focus on ECR (DDU), ER (ASN, HWH),
and NR (UMB).
"""

LOCATION_MASTER = {
    # -------------------------------------------------------------
    # 1. EAST CENTRAL RAILWAY (ECR)
    # -------------------------------------------------------------
    "ECR": {
        "zone_name": "East Central Railway",
        "divisions": {
            "DDU": {
                "name": "Pt. Deen Dayal Upadhyaya (DDU)",
                "sub_divisions": {
                    "DDU-GAYA": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN1",
                        "sections": [
                            {
                                "section_id": "SEC_DDU_GAYA_SSM_DOS",
                                "section_name": "Sasaram - Dehri-on-Sone",
                                "from_station": "SSM",
                                "to_station": "DOS",
                                "distance_km": 18.3,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "SSM", "name": "Sasaram Jn", "csr": 750, "junction": True},
                                    {"code": "KVD", "name": "Khurmabad Road", "csr": 680, "junction": False},
                                    {"code": "DOS", "name": "Dehri-on-Sone", "csr": 750, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_DDU_GAYA_DOS_GAYA",
                                "section_name": "Dehri-on-Sone - Gaya",
                                "from_station": "DOS",
                                "to_station": "GAYA",
                                "distance_km": 65.5,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "UP_CHORD", "DOWN_CHORD"],
                                "stations": [
                                    {"code": "DOS", "name": "Dehri-on-Sone", "csr": 750, "junction": True},
                                    {"code": "SEB", "name": "Son Nagar Jn", "csr": 720, "junction": True},
                                    {"code": "AUBR", "name": "Anugraha Narayan Road", "csr": 700, "junction": False},
                                    {"code": "RFJ", "name": "Rafiganj", "csr": 690, "junction": False},
                                    {"code": "GRRU", "name": "Guraru", "csr": 680, "junction": False},
                                    {"code": "GAYA", "name": "Gaya Jn", "csr": 780, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_DDU_GAYA_DDU_SSM",
                                "section_name": "DDU - Sasaram",
                                "from_station": "DDU",
                                "to_station": "SSM",
                                "distance_km": 100.2,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "DDU", "name": "Pt. Deen Dayal Upadhyaya Jn", "csr": 800, "junction": True},
                                    {"code": "CDMR", "name": "Chandauli Majhwar", "csr": 710, "junction": False},
                                    {"code": "BBU", "name": "Bhabua Road", "csr": 730, "junction": True},
                                    {"code": "KTQ", "name": "Kudra", "csr": 690, "junction": False},
                                    {"code": "SSM", "name": "Sasaram Jn", "csr": 750, "junction": True}
                                ]
                            }
                        ]
                    },
                    "DDU-BDL": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN1",
                        "sections": [
                            {
                                "section_id": "SEC_DDU_BDL_KCA_SLD",
                                "section_name": "Kuchman - Sakaldiha",
                                "from_station": "KCA",
                                "to_station": "SLD",
                                "distance_km": 12.5,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "UP_LOOP", "DOWN_LOOP"],
                                "stations": [
                                    {"code": "DDU", "name": "Pt. Deen Dayal Upadhyaya Jn", "csr": 800, "junction": True},
                                    {"code": "KCA", "name": "Kuchman", "csr": 700, "junction": False},
                                    {"code": "SLD", "name": "Sakaldiha", "csr": 710, "junction": False}
                                ]
                            }
                        ]
                    }
                }
            },
            "DNR": {
                "name": "Danapur (DNR)",
                "sub_divisions": {
                    "DNR-MKA": {
                        "corridor": "MAIN_CORRIDOR",
                        "sections": [
                            {
                                "section_id": "SEC_DNR_PNBE_MKA",
                                "section_name": "Danapur - Patna - Mokama",
                                "from_station": "DNR",
                                "to_station": "MKA",
                                "distance_km": 92.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "3RD_LINE"],
                                "stations": [
                                    {"code": "DNR", "name": "Danapur", "csr": 740, "junction": True},
                                    {"code": "PNBE", "name": "Patna Jn", "csr": 800, "junction": True},
                                    {"code": "PNC", "name": "Patna Saheb", "csr": 710, "junction": False},
                                    {"code": "FUT", "name": "Fatwa", "csr": 690, "junction": False},
                                    {"code": "BKP", "name": "Bakhtiyarpur Jn", "csr": 720, "junction": True},
                                    {"code": "MKA", "name": "Mokama", "csr": 750, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            },
            "DHN": {
                "name": "Dhanbad (DHN)",
                "sub_divisions": {
                    "DHN-GMO-KQR": {
                        "corridor": "GRAND_CHORD_FREIGHT",
                        "sections": [
                            {
                                "section_id": "SEC_DHN_GMO_PNME",
                                "section_name": "Dhanbad - Gomoh - Parasnath",
                                "from_station": "DHN",
                                "to_station": "PNME",
                                "distance_km": 48.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "GOODS_LOOP"],
                                "stations": [
                                    {"code": "DHN", "name": "Dhanbad Jn", "csr": 760, "junction": True},
                                    {"code": "GMO", "name": "NSCB Gomoh Jn", "csr": 780, "junction": True},
                                    {"code": "PNME", "name": "Parasnath", "csr": 720, "junction": False}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 2. EASTERN RAILWAY (ER)
    # -------------------------------------------------------------
    "ER": {
        "zone_name": "Eastern Railway",
        "divisions": {
            "ASN": {
                "name": "Asansol (ASN)",
                "sub_divisions": {
                    "ASN-UDL-SNT": {
                        "corridor": "FEEDER_CORRIDOR_MINING",
                        "sections": [
                            {
                                "section_id": "SEC_ASN_UDL_SNT",
                                "section_name": "Andal - Sainthia",
                                "from_station": "UDL",
                                "to_station": "SNT",
                                "distance_km": 72.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "SINGLE_LINE"],
                                "stations": [
                                    {"code": "UDL", "name": "Andal Jn", "csr": 750, "junction": True},
                                    {"code": "UKA", "name": "Ukhra", "csr": 680, "junction": False},
                                    {"code": "PAW", "name": "Pandabeswar", "csr": 690, "junction": False},
                                    {"code": "DUJ", "name": "Dubrajpur", "csr": 670, "junction": False},
                                    {"code": "SURI", "name": "Siuri", "csr": 710, "junction": False},
                                    {"code": "SNT", "name": "Sainthia Jn", "csr": 750, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_ASN_UDL_STN",
                                "section_name": "Andal - Sitarampur Loop",
                                "from_station": "UDL",
                                "to_station": "STN",
                                "distance_km": 35.0,
                                "lines": ["GOODS_CHORD", "UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "UDL", "name": "Andal Jn", "csr": 750, "junction": True},
                                    {"code": "TOP", "name": "Tapasi", "csr": 680, "junction": False},
                                    {"code": "BBI", "name": "Barabani", "csr": 690, "junction": False},
                                    {"code": "STN", "name": "Sitarampur Jn", "csr": 740, "junction": True}
                                ]
                            }
                        ]
                    },
                    "ASN-MDP-JSME": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN1",
                        "sections": [
                            {
                                "section_id": "SEC_ASN_MDP_GRD",
                                "section_name": "Madhupur - Giridih",
                                "from_station": "MDP",
                                "to_station": "GRD",
                                "distance_km": 38.0,
                                "lines": ["SINGLE_LINE"],
                                "stations": [
                                    {"code": "MDP", "name": "Madhupur Jn", "csr": 720, "junction": True},
                                    {"code": "JGD", "name": "Jagdishpur", "csr": 650, "junction": False},
                                    {"code": "MMD", "name": "Maheshmunda", "csr": 700, "junction": False},
                                    {"code": "GRD", "name": "Giridih", "csr": 680, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_ASN_JSME_DGHR",
                                "section_name": "Jasidih - Deoghar",
                                "from_station": "JSME",
                                "to_station": "DGHR",
                                "distance_km": 6.5,
                                "lines": ["SINGLE_LINE", "UP_MAIN"],
                                "stations": [
                                    {"code": "JSME", "name": "Jasidih Jn", "csr": 760, "junction": True},
                                    {"code": "DGHR", "name": "Deoghar Jn", "csr": 720, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_ASN_MAIN_STN_CRJ_MDP",
                                "section_name": "Asansol - Chittaranjan - Madhupur",
                                "from_station": "ASN",
                                "to_station": "MDP",
                                "distance_km": 82.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "ASN", "name": "Asansol Jn", "csr": 800, "junction": True},
                                    {"code": "STN", "name": "Sitarampur Jn", "csr": 740, "junction": True},
                                    {"code": "CRJ", "name": "Chittaranjan", "csr": 760, "junction": False},
                                    {"code": "JMT", "name": "Jamtara", "csr": 710, "junction": False},
                                    {"code": "MDP", "name": "Madhupur Jn", "csr": 720, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            },
            "HWH": {
                "name": "Howrah (HWH)",
                "sub_divisions": {
                    "HWH-MAIN-CHORD": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN1",
                        "sections": [
                            {
                                "section_id": "SEC_HWH_MAIN_BWN",
                                "section_name": "Howrah - Barddhaman Main Line",
                                "from_station": "HWH",
                                "to_station": "BWN",
                                "distance_km": 107.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "UP_CHORD", "DOWN_CHORD"],
                                "stations": [
                                    {"code": "HWH", "name": "Howrah Jn", "csr": 850, "junction": True},
                                    {"code": "BLY", "name": "Bally", "csr": 700, "junction": False},
                                    {"code": "SHE", "name": "Sheoraphuli Jn", "csr": 740, "junction": True},
                                    {"code": "BDC", "name": "Bandel Jn", "csr": 780, "junction": True},
                                    {"code": "MYM", "name": "Memari", "csr": 710, "junction": False},
                                    {"code": "BWN", "name": "Barddhaman Jn", "csr": 820, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_HWH_CHORD_DKAE_BWN",
                                "section_name": "Dankuni - Barddhaman Chord",
                                "from_station": "DKAE",
                                "to_station": "BWN",
                                "distance_km": 88.0,
                                "lines": ["UP_CHORD", "DOWN_CHORD"],
                                "stations": [
                                    {"code": "DKAE", "name": "Dankuni Jn", "csr": 770, "junction": True},
                                    {"code": "KQU", "name": "Kamarkundu", "csr": 700, "junction": True},
                                    {"code": "MSAE", "name": "Masagram", "csr": 710, "junction": True},
                                    {"code": "BWN", "name": "Barddhaman Jn", "csr": 820, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_HWH_BDC_AZ",
                                "section_name": "Bandel - Azimganj",
                                "from_station": "BDC",
                                "to_station": "AZ",
                                "distance_km": 145.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "SINGLE_LINE"],
                                "stations": [
                                    {"code": "BDC", "name": "Bandel Jn", "csr": 780, "junction": True},
                                    {"code": "NDAE", "name": "Nabadwip Dham", "csr": 730, "junction": False},
                                    {"code": "KWAE", "name": "Katwa Jn", "csr": 750, "junction": True},
                                    {"code": "SALE", "name": "Salar", "csr": 680, "junction": False},
                                    {"code": "AZ", "name": "Azimganj Jn", "csr": 740, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_HWH_SHE_TAK",
                                "section_name": "Sheoraphuli - Tarakeswar",
                                "from_station": "SHE",
                                "to_station": "TAK",
                                "distance_km": 35.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "SHE", "name": "Sheoraphuli Jn", "csr": 740, "junction": True},
                                    {"code": "DEA", "name": "Diara", "csr": 650, "junction": False},
                                    {"code": "TAK", "name": "Tarakeswar", "csr": 710, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 3. NORTHERN RAILWAY (NR)
    # -------------------------------------------------------------
    "NR": {
        "zone_name": "Northern Railway",
        "divisions": {
            "UMB": {
                "name": "Ambala (UMB)",
                "sub_divisions": {
                    "UMB-LDH-CORRIDOR": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN2",
                        "sections": [
                            {
                                "section_id": "SEC_UMB_LDH_MAIN",
                                "section_name": "Ambala Cantt - Ludhiana",
                                "from_station": "UMB",
                                "to_station": "LDH",
                                "distance_km": 114.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 800, "junction": True},
                                    {"code": "RPJ", "name": "Rajpura Jn", "csr": 760, "junction": True},
                                    {"code": "SIR", "name": "Sirhind Jn", "csr": 750, "junction": True},
                                    {"code": "KNN", "name": "Khanna", "csr": 710, "junction": False},
                                    {"code": "DOA", "name": "Doraha", "csr": 690, "junction": False},
                                    {"code": "LDH", "name": "Ludhiana Jn", "csr": 820, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_UMB_CDG_KLK",
                                "section_name": "Ambala - Chandigarh - Kalka",
                                "from_station": "UMB",
                                "to_station": "KLK",
                                "distance_km": 68.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "SINGLE_LINE"],
                                "stations": [
                                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 800, "junction": True},
                                    {"code": "DKT", "name": "Dhulkot", "csr": 670, "junction": False},
                                    {"code": "CDG", "name": "Chandigarh Jn", "csr": 790, "junction": True},
                                    {"code": "CPN", "name": "Chandi Mandir", "csr": 680, "junction": False},
                                    {"code": "KLK", "name": "Kalka", "csr": 730, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_UMB_SRE_MAIN",
                                "section_name": "Ambala Cantt - Saharanpur",
                                "from_station": "UMB",
                                "to_station": "SRE",
                                "distance_km": 81.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 800, "junction": True},
                                    {"code": "RAA", "name": "Barara", "csr": 690, "junction": False},
                                    {"code": "JUDW", "name": "Jagadhri Workshop", "csr": 720, "junction": False},
                                    {"code": "YJUD", "name": "Yamunanagar Jagadhri", "csr": 740, "junction": False},
                                    {"code": "SRE", "name": "Saharanpur Jn", "csr": 790, "junction": True}
                                ]
                            },
                            {
                                "section_id": "SEC_UMB_RPJ_BTI",
                                "section_name": "Rajpura - Dhuri - Bathinda",
                                "from_station": "RPJ",
                                "to_station": "BTI",
                                "distance_km": 172.0,
                                "lines": ["SINGLE_LINE", "UP_MAIN"],
                                "stations": [
                                    {"code": "RPJ", "name": "Rajpura Jn", "csr": 760, "junction": True},
                                    {"code": "PTA", "name": "Patiala", "csr": 720, "junction": False},
                                    {"code": "NBA", "name": "Nabha", "csr": 690, "junction": False},
                                    {"code": "DUI", "name": "Dhuri Jn", "csr": 750, "junction": True},
                                    {"code": "BNT", "name": "Barnala", "csr": 680, "junction": False},
                                    {"code": "BTI", "name": "Bathinda Jn", "csr": 810, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            },
            "DLI": {
                "name": "Delhi (DLI)",
                "sub_divisions": {
                    "DLI-NDLS-GZB": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN1",
                        "sections": [
                            {
                                "section_id": "SEC_NDLS_GZB_MAIN",
                                "section_name": "New Delhi - Ghaziabad",
                                "from_station": "NDLS",
                                "to_station": "GZB",
                                "distance_km": 25.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "3RD_LINE", "4TH_LINE"],
                                "stations": [
                                    {"code": "NDLS", "name": "New Delhi", "csr": 850, "junction": True},
                                    {"code": "ANVR", "name": "Anand Vihar", "csr": 800, "junction": True},
                                    {"code": "SBB", "name": "Sahibabad", "csr": 740, "junction": False},
                                    {"code": "GZB", "name": "Ghaziabad Jn", "csr": 820, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 4. CENTRAL RAILWAY (CR)
    # -------------------------------------------------------------
    "CR": {
        "zone_name": "Central Railway",
        "divisions": {
            "CSMT": {
                "name": "Mumbai (CSMT)",
                "sub_divisions": {
                    "CSMT-KYN-KSRA": {
                        "corridor": "SUBURBAN_AND_MAINLINE",
                        "sections": [
                            {
                                "section_id": "SEC_CSMT_KYN_KSRA",
                                "section_name": "Kalyan - Kasara",
                                "from_station": "KYN",
                                "to_station": "KSRA",
                                "distance_km": 67.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "KYN", "name": "Kalyan Jn", "csr": 820, "junction": True},
                                    {"code": "TLA", "name": "Titwala", "csr": 720, "junction": False},
                                    {"code": "ATG", "name": "Atgaon", "csr": 690, "junction": False},
                                    {"code": "KSRA", "name": "Kasara", "csr": 780, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 5. WESTERN RAILWAY (WR)
    # -------------------------------------------------------------
    "WR": {
        "zone_name": "Western Railway",
        "divisions": {
            "MMCT": {
                "name": "Mumbai Central (MMCT)",
                "sub_divisions": {
                    "BVI-VR-DRD": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN3",
                        "sections": [
                            {
                                "section_id": "SEC_VR_DRD_MAIN",
                                "section_name": "Virar - Dahanu Road",
                                "from_station": "VR",
                                "to_station": "DRD",
                                "distance_km": 64.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "VR", "name": "Virar", "csr": 760, "junction": True},
                                    {"code": "SAH", "name": "Saphale", "csr": 700, "junction": False},
                                    {"code": "PLG", "name": "Palghar", "csr": 730, "junction": False},
                                    {"code": "DRD", "name": "Dahanu Road", "csr": 760, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            },
            "BRC": {
                "name": "Vadodara (BRC)",
                "sub_divisions": {
                    "ST-BRC": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN3",
                        "sections": [
                            {
                                "section_id": "SEC_ST_BH_BRC",
                                "section_name": "Surat - Bharuch - Vadodara",
                                "from_station": "ST",
                                "to_station": "BRC",
                                "distance_km": 129.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "3RD_LINE"],
                                "stations": [
                                    {"code": "ST", "name": "Surat", "csr": 800, "junction": True},
                                    {"code": "BH", "name": "Bharuch Jn", "csr": 750, "junction": True},
                                    {"code": "BRC", "name": "Vadodara Jn", "csr": 850, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 6. NORTH CENTRAL RAILWAY (NCR)
    # -------------------------------------------------------------
    "NCR": {
        "zone_name": "North Central Railway",
        "divisions": {
            "PRYJ": {
                "name": "Prayagraj (PRYJ)",
                "sub_divisions": {
                    "PRYJ-CNB": {
                        "corridor": "HIGH_DENSITY_NETWORK_HDN1",
                        "sections": [
                            {
                                "section_id": "SEC_PRYJ_FTP_CNB",
                                "section_name": "Prayagraj - Fatehpur - Kanpur",
                                "from_station": "PRYJ",
                                "to_station": "CNB",
                                "distance_km": 195.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "3RD_LINE"],
                                "stations": [
                                    {"code": "PRYJ", "name": "Prayagraj Jn", "csr": 820, "junction": True},
                                    {"code": "FTP", "name": "Fatehpur", "csr": 740, "junction": False},
                                    {"code": "CNB", "name": "Kanpur Central", "csr": 850, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 7. SOUTH CENTRAL RAILWAY (SCR)
    # -------------------------------------------------------------
    "SCR": {
        "zone_name": "South Central Railway",
        "divisions": {
            "SC": {
                "name": "Secunderabad (SC)",
                "sub_divisions": {
                    "KZJ-SC": {
                        "corridor": "MAINLINE",
                        "sections": [
                            {
                                "section_id": "SEC_KZJ_SC_MAIN",
                                "section_name": "Kazipet - Secunderabad",
                                "from_station": "KZJ",
                                "to_station": "SC",
                                "distance_km": 132.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "KZJ", "name": "Kazipet Jn", "csr": 780, "junction": True},
                                    {"code": "ZN", "name": "Jangaon", "csr": 700, "junction": False},
                                    {"code": "BG", "name": "Bhongir", "csr": 710, "junction": False},
                                    {"code": "SC", "name": "Secunderabad Jn", "csr": 840, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 8. SOUTHERN RAILWAY (SR)
    # -------------------------------------------------------------
    "SR": {
        "zone_name": "Southern Railway",
        "divisions": {
            "MAS": {
                "name": "Chennai (MAS)",
                "sub_divisions": {
                    "MAS-AJJ-KPD": {
                        "corridor": "HIGH_DENSITY_NETWORK",
                        "sections": [
                            {
                                "section_id": "SEC_MAS_AJJ_KPD",
                                "section_name": "Chennai - Arakkonam - Katpadi",
                                "from_station": "MAS",
                                "to_station": "KPD",
                                "distance_km": 130.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "UP_FAST", "DOWN_FAST"],
                                "stations": [
                                    {"code": "MAS", "name": "Chennai Central", "csr": 850, "junction": True},
                                    {"code": "TRL", "name": "Tiruvallur", "csr": 720, "junction": False},
                                    {"code": "AJJ", "name": "Arakkonam Jn", "csr": 790, "junction": True},
                                    {"code": "KPD", "name": "Katpadi Jn", "csr": 800, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 9. SOUTH EASTERN RAILWAY (SER)
    # -------------------------------------------------------------
    "SER": {
        "zone_name": "South Eastern Railway",
        "divisions": {
            "KGP": {
                "name": "Kharagpur (KGP)",
                "sub_divisions": {
                    "HWH-KGP-TATA": {
                        "corridor": "MINING_AND_TRUNK",
                        "sections": [
                            {
                                "section_id": "SEC_KGP_JGM_TATA",
                                "section_name": "Kharagpur - Tatanagar",
                                "from_station": "KGP",
                                "to_station": "TATA",
                                "distance_km": 135.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN", "3RD_LINE"],
                                "stations": [
                                    {"code": "KGP", "name": "Kharagpur Jn", "csr": 850, "junction": True},
                                    {"code": "JGM", "name": "Jhargram", "csr": 730, "junction": False},
                                    {"code": "GTS", "name": "Ghatsila", "csr": 720, "junction": False},
                                    {"code": "TATA", "name": "Tatanagar Jn", "csr": 820, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    },
    # -------------------------------------------------------------
    # 10. WEST CENTRAL RAILWAY (WCR)
    # -------------------------------------------------------------
    "WCR": {
        "zone_name": "West Central Railway",
        "divisions": {
            "KOTA": {
                "name": "Kota (KOTA)",
                "sub_divisions": {
                    "KOTA-SWM": {
                        "corridor": "HIGH_SPEED_TRUNK",
                        "sections": [
                            {
                                "section_id": "SEC_KOTA_SWM_MAIN",
                                "section_name": "Kota - Sawai Madhopur",
                                "from_station": "KOTA",
                                "to_station": "SWM",
                                "distance_km": 108.0,
                                "lines": ["UP_MAIN", "DOWN_MAIN"],
                                "stations": [
                                    {"code": "KOTA", "name": "Kota Jn", "csr": 820, "junction": True},
                                    {"code": "LKE", "name": "Lakheri", "csr": 700, "junction": False},
                                    {"code": "SWM", "name": "Sawai Madhopur Jn", "csr": 800, "junction": True}
                                ]
                            }
                        ]
                    }
                }
            }
        }
    }
}
