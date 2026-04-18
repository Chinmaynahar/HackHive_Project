// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firebase_processed_service.dart';
import '../services/ml_backend_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class LiveProcessedScreen extends StatefulWidget {
  const LiveProcessedScreen({super.key});

  @override
  State<LiveProcessedScreen> createState() => _LiveProcessedScreenState();
}

class _LiveProcessedScreenState extends State<LiveProcessedScreen> {
  final _processedService = FirebaseProcessedDataService();
  final _backendService = MLBackendService();
  StreamSubscription<Map<String, dynamic>?>? _subscription;
  Map<String, dynamic>? _latestData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _processedService.startListening();
    _subscription = _processedService.onProcessedData.listen((data) {
      if (!mounted) return;
      setState(() {
        _latestData = data;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshPrediction();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _processedService.dispose();
    super.dispose();
  }

  Future<void> _refreshPrediction() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _backendService.triggerClassification();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prediction = _latestData?['prediction']?.toString() ?? 'Waiting for data';
    final confidence = _latestData?['confidence']?.toString() ?? '--';
    final sourceLabel = _latestData?['source_label']?.toString() ?? 'Unknown';
    final timestamp = _latestData?['timestamp'];
    final rawSensor = _latestData?['raw_sensor'];
    final updatedAt = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal()
        : null;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppTheme.cardDark,
        elevation: 0,
        title: const Text('Live ASL Feed'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Raw glove data is read from Firebase, classified by the ML backend, and displayed here in real time.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppTheme.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard('Predicted letter', prediction),
              const SizedBox(height: 12),
              _buildInfoCard('Confidence', confidence),
              const SizedBox(height: 12),
              _buildInfoCard('Label from source data', sourceLabel),
              const SizedBox(height: 12),
              if (updatedAt != null)
                _buildInfoCard('Updated at', '${updatedAt.toLocal()}'),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.error.withOpacity(0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              PrimaryButton(
                label: _isLoading ? 'Refreshing...' : 'Refresh Classification',
                onTap: _isLoading ? () {} : _refreshPrediction,
                color1: AppTheme.ppPrimary,
                color2: const Color(0xFFFBBF24),
              ),
              const SizedBox(height: 18),
              if (rawSensor is Map<String, dynamic>)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppTheme.border,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rawSensor.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    color: AppTheme.muted,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
