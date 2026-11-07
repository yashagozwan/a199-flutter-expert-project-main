import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:tv/presentation/bloc/tv_season_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeasonDetailArgs {
  final int tvId;
  final String tvName;
  final int seasonNumber;

  TvSeasonDetailArgs({
    required this.tvId,
    required this.tvName,
    required this.seasonNumber,
  });
}

class TvSeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-season-detail';

  final TvSeasonDetailArgs args;

  TvSeasonDetailPage({required this.args});

  @override
  _TvSeasonDetailPageState createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvSeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvSeasonDetailBloc>().add(
            FetchTvSeasonDetail(widget.args.tvId, widget.args.seasonNumber),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.args.tvName} - Season ${widget.args.seasonNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeasonDetailBloc, TvSeasonDetailState>(
          builder: (context, state) {
            if (state is TvSeasonDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSeasonDetailHasData) {
              final season = state.result;
              if (season.episodes.isEmpty) {
                return Center(
                  child: Text('No episodes found'),
                );
              }
              return ListView.builder(
                itemCount: season.episodes.length,
                itemBuilder: (context, index) {
                  final episode = season.episodes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: episode.stillPath != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        '$BASE_IMAGE_URL${episode.stillPath}',
                                    width: 100,
                                    height: 65,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Container(
                                    width: 100,
                                    height: 65,
                                    color: kGrey,
                                    child: Icon(Icons.tv),
                                  ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${episode.episodeNumber}. ${episode.name}',
                                  style: kSubtitle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                if (episode.airDate != null &&
                                    episode.airDate!.isNotEmpty)
                                  Text(
                                    episode.airDate!,
                                    style: kBodyText.copyWith(
                                        color: Colors.grey.shade400),
                                  ),
                                SizedBox(height: 4),
                                Text(
                                  episode.overview.isNotEmpty
                                      ? episode.overview
                                      : 'No overview available.',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: kBodyText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is TvSeasonDetailError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(''),
              );
            }
          },
        ),
      ),
    );
  }
}
