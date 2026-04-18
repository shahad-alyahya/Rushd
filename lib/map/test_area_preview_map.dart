import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestAreaPreviewMap extends StatelessWidget {
  const TestAreaPreviewMap({super.key});

  static const LatLng center = LatLng(24.8259576, 46.6638939);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: center,
            zoom: 16,
          ),
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,

          markers: {
            const Marker(
              markerId: MarkerId('center'),
              position: center,
            ),
          },

          polygons: {
            Polygon(
              polygonId: const PolygonId('test_area'),
              points: const [
                LatLng(24.8276617, 46.6648032),
                LatLng(24.8276416, 46.6648491),
                LatLng(24.8269828, 46.6651905),
                LatLng(24.8267646, 46.6652491),
                LatLng(24.8264107, 46.6651915),
                LatLng(24.8255983, 46.6648656),
                LatLng(24.8248832, 46.6645665),
                LatLng(24.8244970, 46.6643845),
                LatLng(24.8242971, 46.6641843),
                LatLng(24.8240601, 46.6636157),
                LatLng(24.8239791, 46.6634024),
                LatLng(24.8240293, 46.6632744),
                LatLng(24.8264116, 46.6620657),
                LatLng(24.8264354, 46.6620674),
                LatLng(24.8265352, 46.6621032),
                LatLng(24.8271270, 46.6635590),
              ],
              strokeWidth: 0,
              strokeColor: Color(0xFF867AB9),
              fillColor: Color(0x553B82F6),
            ),
          },
        ),

        /// النص بالنص
        const Center(
          child: Text(
            "Test Area",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              
            ),
          ),
        ),
      ],
    );
  }
}