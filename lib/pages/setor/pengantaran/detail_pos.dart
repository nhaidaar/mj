import 'package:flutter/material.dart';
import 'package:mj/models/warehouse_model.dart';
import 'package:mj/pages/setor/pengantaran/rute_pengantaran.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:page_transition/page_transition.dart';

import '../../../services/maps_service.dart';
import '../../../shared/const.dart';

class DetailPos extends StatelessWidget {
  final WarehouseModel warehouse;
  final int distance;
  const DetailPos({
    super.key,
    required this.warehouse,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
        ),
        title: Text(
          'Detail Pos',
          style: boldTS.copyWith(color: blackColor),
        ),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: warehouse.imgUrl != ''
                    ? NetworkImage(warehouse.imgUrl!) as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: white3Color),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            warehouse.title.toString(),
            style: boldTS.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 12,
          ),
          FutureBuilder(
            future: MapsService().getShortAddressFromLatLng(
                warehouse.latitude!, warehouse.longitude!),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Getting your Location...',
                style: mediumTS.copyWith(
                  color: warehouse.isAvailable! ? blackColor : blackBlur50Color,
                ),
              );
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Container(
                height: 12,
                width: 12,
                decoration: ShapeDecoration(
                  shape: const CircleBorder(),
                  color: warehouse.isAvailable! ? greenColor : Colors.redAccent,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '${(warehouse.isAvailable! ? 'Buka' : 'Tutup')} - $distance m dari lokasi pilihan Anda',
                style: semiboldTS.copyWith(
                  fontSize: 16,
                  color: warehouse.isAvailable! ? blackColor : blackBlur50Color,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Panduan penyetoran minyak jelantah di ${warehouse.title}',
            style: semiboldTS.copyWith(fontSize: 18),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            '1. Ketika anda sampai di pos penyetoran limbah minyak jelantah, silahkan menuju ke petugas untuk melakukan penimbangan minyak jelantah.\n2. Setelah penimbangan dilakukan, Anda akan melakukan pengisian data kepada petugas.\n3. Setelah pengisian data dilakukan, maka Anda akan diberi barcode untuk discan guna melihat detail setoran minyak Anda.\n4. Setelah detail setor minyak muncul, maka Anda mendapatkan informasi tentang setoran dan bisa mengklaim poin Anda.',
            style: regularTS,
            textAlign: TextAlign.justify,
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: warehouse.isAvailable!
            ? CustomContinue(
                text: 'Tunjukkan Rute',
                action: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: TunjukkanRute(
                          warehouse: warehouse,
                        ),
                        type: PageTransitionType.fade),
                  );
                },
              )
            : CustomContinue(
                text: 'Tunjukkan Rute',
                bgColor: white3Color,
              ),
      ),
    );
  }
}
