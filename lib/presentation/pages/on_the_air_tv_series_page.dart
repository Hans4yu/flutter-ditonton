import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_event.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_state.dart';
import 'package:ditonton/presentation/widgets/cinematic_widgets.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvSeriesPage extends StatefulWidget {
  const OnTheAirTvSeriesPage({super.key});

  static const ROUTE_NAME = '/on-the-air-tv-series';

  @override
  State<OnTheAirTvSeriesPage> createState() => _OnTheAirTvSeriesPageState();
}

class _OnTheAirTvSeriesPageState extends State<OnTheAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OnTheAirTvSeriesBloc>().add(const FetchOnTheAirTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
          builder: (context, data) {
            if (data.state == RequestState.Loading) {
              return const LoadingView();
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
