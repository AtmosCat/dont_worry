import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

Future<void> showInterstitialAd(BuildContext context, VoidCallback onAdClosed) async {
  InterstitialAd.load(
    // adUnitId: 'ca-app-pub-8181369336901289/2103455510', // 실제 키
    adUnitId: 'ca-app-pub-3940256099942544/1033173712', // 테스트 키
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            onAdClosed(); // 광고 닫힌 뒤 후속 동작 실행
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            onAdClosed(); // 실패 시에도 후속 동작 실행
          },
        );
        ad.show();
      },
      onAdFailedToLoad: (error) {
        onAdClosed(); // 광고 로드 실패 시에도 후속 동작 실행
      },
    ),
  );
}
