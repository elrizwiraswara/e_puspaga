import 'package:flutter/material.dart';

import '../../model/user/gender_model.dart';
import '../themes/app_colors.dart';

late Size screenSize;

List<MenuItemModel> conselingMedium = [
  MenuItemModel(id: 'online', name: 'Online'),
  MenuItemModel(id: 'offline', name: 'Offline'),
];

List<MenuItemModel> genderMenuItems = [
  MenuItemModel(id: 'male', name: 'Laki-Laki'),
  MenuItemModel(id: 'female', name: 'Perempuan'),
];

List<MenuItemModel> religionMenuItems = [
  MenuItemModel(id: 'islam', name: 'Islam'),
  MenuItemModel(id: 'protestan', name: 'Kristen Protestan'),
  MenuItemModel(id: 'katolik', name: 'Kristen Katolik'),
  MenuItemModel(id: 'hindu', name: 'Hindu'),
  MenuItemModel(id: 'budha', name: 'Budha'),
  MenuItemModel(id: 'khonghucu', name: 'Khonghucu'),
];

List<int> scheduleStatusId = [0, 1, 2, 3, 4];

String scheduleStatusName(int? status) {
  switch (status) {
    case 0:
      // created
      return 'Menunggu Konfirmasi';
    case 1:
      // confirmed
      return 'Jadwal Dikonfirmasi';
    case 2:
      // complete
      return 'Tidak Dapat Dikonfirmasi';
    case 3:
      // cancelled
      return 'Selesai';
    case 4:
      // cancelled
      return 'Dibatalkan';
    default:
      return 'Menunggu Konfirmasi';
  }
}

Color scheduleStatusColor(int? status) {
  switch (status) {
    case 0:
      return AppColors.blackLv1;
    case 1:
      return AppColors.blackLv1;
    case 2:
      return AppColors.redLv1;
    case 3:
      return AppColors.greenLv1;
    case 4:
      return AppColors.redLv1;
    default:
      return AppColors.blackLv1;
  }
}

List<Map<String, dynamic>> dumaiLocations = [
  {
    "id": "0",
    "name": "Kota Dumai",
    "district": [
      {
        "id": "1",
        "name": "Dumai Barat",
        "village": [
          {
            "id": "11",
            "name": "Bagan Keladi",
          },
          {
            "id": "12",
            "name": "Pangkalan Sesai",
          },
          {
            "id": "13",
            "name": "Purnama",
          },
          {
            "id": "14",
            "name": "Simpang Tetap Darul Ichsan",
          },
        ]
      },
      {
        "id": "2",
        "name": "Dumai Timur",
        "village": [
          {
            "id": "21",
            "name": "Bukit Batrem",
          },
          {
            "id": "22",
            "name": "Buluh Kasap",
          },
          {
            "id": "23",
            "name": "Jaya Mukti",
          },
          {
            "id": "24",
            "name": "Tanjung Palas",
          },
          {
            "id": "25",
            "name": "Teluk Binjai",
          },
        ]
      },
      {
        "id": "3",
        "name": "Bukit Kapur",
        "village": [
          {
            "id": "31",
            "name": "Bagan Besar",
          },
          {
            "id": "32",
            "name": "Bukit Kayu Kapur",
          },
          {
            "id": "33",
            "name": "Bukit Nenas",
          },
          {
            "id": "34",
            "name": "Gurun Panjang",
          },
          {
            "id": "35",
            "name": "Kampung Baru",
          },
          {
            "id": "36",
            "name": "Bagan Besar Timur",
          },
          {
            "id": "37",
            "name": "Bukit Kapur",
          },
        ]
      },
      {
        "id": "4",
        "name": "Sungai Sembilan",
        "village": [
          {
            "id": "41",
            "name": "Bangsal Aceh",
          },
          {
            "id": "42",
            "name": "Basilam Baru",
          },
          {
            "id": "43",
            "name": "Batu Teritip",
          },
          {
            "id": "44",
            "name": "Lubuk Gaung",
          },
          {
            "id": "45",
            "name": "Tanjung Penyembal",
          },
          {
            "id": "46",
            "name": "Sungai Geniot",
          },
        ]
      },
      {
        "id": "5",
        "name": "Medang Kampai",
        "village": [
          {
            "id": "51",
            "name": "Guntung",
          },
          {
            "id": "52",
            "name": "Mundam",
          },
          {
            "id": "53",
            "name": "Pelintung",
          },
          {
            "id": "54",
            "name": "Teluk Makmur",
          },
        ]
      },
      {
        "id": "6",
        "name": "Dumai Kota",
        "village": [
          {
            "id": "61",
            "name": "Rimba Sekampung",
          },
          {
            "id": "62",
            "name": "Laksamana",
          },
          {
            "id": "63",
            "name": "Dumai Kota",
          },
          {
            "id": "64",
            "name": "Bintan",
          },
          {
            "id": "65",
            "name": "Sukajadi",
          },
        ]
      },
      {
        "id": "7",
        "name": "Dumai Selatan",
        "village": [
          {
            "id": "71",
            "name": "Bukit Datuk",
          },
          {
            "id": "72",
            "name": "Mekar Sari",
          },
          {
            "id": "7",
            "name": "Bukit Timah",
          },
          {
            "id": "74",
            "name": "Ratu Sima",
          },
          {
            "id": "75",
            "name": "Bumi Ayu",
          },
        ]
      },
    ],
  },
];
