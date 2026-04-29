import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('SectionHeader shows see all action when callback is provided',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(makeTestableWidget(
      SectionHeader(
        title: 'Popular',
        onSeeAll: () => tapped = true,
      ),
    ));

    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);

    await tester.tap(find.text('See all'));

    expect(tapped, isTrue);
  });

  testWidgets('RatingBadge formats null and non-null ratings', (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      const Column(
        children: [
          RatingBadge(rating: 7.25),
          RatingBadge(rating: null, compact: true),
        ],
      ),
    ));

    expect(find.byIcon(Icons.star_rounded), findsNWidgets(2));
    expect(find.text('7.3'), findsOneWidget);
    expect(find.text('0.0'), findsOneWidget);
  });

  testWidgets('PrimaryWatchlistButton switches labels and triggers callback',
      (tester) async {
    var addTapped = false;
    var addedTapped = false;

    await tester.pumpWidget(makeTestableWidget(
      Column(
        children: [
          PrimaryWatchlistButton(
            isAdded: false,
            onPressed: () => addTapped = true,
          ),
          PrimaryWatchlistButton(
            isAdded: true,
            onPressed: () => addedTapped = true,
          ),
        ],
      ),
    ));

    expect(find.text('Add to Watchlist'), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('Add to Watchlist'));
    await tester.tap(find.text('Added to Watchlist'));

    expect(addTapped, isTrue);
    expect(addedTapped, isTrue);
  });

  testWidgets('EmptyStateView renders full and compact states safely',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      Column(
        children: [
          const Expanded(
            child: EmptyStateView(
              title: 'No results',
              message: 'Try a different query.',
              assetName: emptySearchAsset,
            ),
          ),
          SizedBox(
            height: 120,
            child: EmptyStateView(
              title: 'No saved movies',
              message: 'Movies added to your watchlist will appear here.',
              assetName: emptyWatchlistAsset,
            ),
          ),
        ],
      ),
    ));

    expect(find.text('No results'), findsOneWidget);
    expect(find.text('Try a different query.'), findsOneWidget);
    expect(find.text('No saved movies'), findsOneWidget);
    expect(
      find.text('Movies added to your watchlist will appear here.'),
      findsOneWidget,
    );
  });

  testWidgets('ErrorStateView uses fallback message when message is empty',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      const ErrorStateView(message: '', height: 320),
    ));

    expect(find.text('Content is unavailable'), findsOneWidget);
    expect(
      find.text('We could not load this section. Please try again later.'),
      findsOneWidget,
    );
  });

  testWidgets('Poster and backdrop views use asset fallback for missing path',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      const Row(
        children: [
          PosterImageView(posterPath: null, width: 80, height: 120),
          BackdropImageView(backdropPath: '', width: 120, height: 80),
        ],
      ),
    ));

    expect(find.byType(Image), findsNWidgets(2));
  });

  testWidgets('PosterGridItem shows title, rating, and handles tap',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(makeTestableWidget(
      SizedBox(
        width: 180,
        height: 280,
        child: PosterGridItem(
          title: 'Apex',
          posterPath: null,
          rating: 6.5,
          onTap: () => tapped = true,
        ),
      ),
    ));

    expect(find.text('Apex'), findsOneWidget);
    expect(find.text('6.5'), findsOneWidget);

    await tester.tap(find.text('Apex'));

    expect(tapped, isTrue);
  });

  testWidgets('LoadingView renders animated sprite at requested height',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget(
      const LoadingView(height: 96),
    ));

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sizedBox.height, 96);
    expect(find.byType(CinematicLoadingSprite), findsOneWidget);
    expect(find.image(const AssetImage(loadingSpriteAsset)), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
