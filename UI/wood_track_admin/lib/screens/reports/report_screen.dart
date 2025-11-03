import 'package:flutter/material.dart';
import 'package:wood_track_admin/screens/order/product_order_list_screen.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';

import '../clients/client_list_screen.dart';
import '../tools/tool_list_screen.dart'; // Dodano za alate

class ReportScreen extends StatefulWidget {
  static const String routeName = "reports";
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Izvještaji',
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Upravljanje izvještajima',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.2,
                  ),
                  children: [
                    _buildReportCard(
                      icon: Icons.people_alt_outlined,
                      title: 'Izvještaj klijenata',
                      description:
                      'Pregledajte statistiku klijenata, te njihove osnovne podatke.',
                      color: Colors.blue[50]!,
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                            const ClientListScreen(),
                          ),
                        );
                      },
                    ),
                    _buildReportCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'Izvještaj narudžbi',
                      description:
                      'Analiza rezervisanih termina, najpopularnije usluge i stopu popunjenosti.',
                      color: Colors.green[50]!,
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                            const ProductOrderListScreen(),
                          ),
                        );
                      },
                    ),
                    _buildReportCard(
                      icon: Icons.build_circle_outlined,
                      title: 'Izvještaj alata',
                      description:
                      'Pratite stanje alata, dostupnost i korištenje tokom projekata.',
                      color: Colors.orange[50]!,
                      iconColor: Colors.deepOrange,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                            const ToolListScreen(), // tvoj screen za alate
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                radius: 24,
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
