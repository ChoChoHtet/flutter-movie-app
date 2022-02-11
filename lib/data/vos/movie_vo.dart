import 'package:json_annotation/json_annotation.dart';
import 'package:module_3_movies_app/data/vos/collection_vo.dart';
import 'package:module_3_movies_app/data/vos/genre_vo.dart';
import 'package:module_3_movies_app/data/vos/production_companies_vo.dart';
import 'package:module_3_movies_app/data/vos/production_countries_vo.dart';
import 'package:module_3_movies_app/data/vos/spoken_languages_vo.dart';

part 'movie_vo.g.dart';
@JsonSerializable()
class MovieVO{
  @JsonKey(name:"adult")
  bool? adult;

  @JsonKey(name:"backdrop_path")
  String? backDropPath;

  @JsonKey(name: "belongs_to_collection")
  CollectionVO? belongToCollection;

  @JsonKey(name: "budget")
  double? budget;

  @JsonKey(name: "genres")
  List<GenreVO>? genres;

  @JsonKey(name: "homepage")
  String? homePage;

  @JsonKey(name:"genre_ids")
  List<int>? genreIds;

  @JsonKey(name:"id")
  int? id;

  @JsonKey(name: "imdb_id")
  String? imdbId;

  @JsonKey(name:"original_language")
  String? originalLanguage;

  @JsonKey(name:"original_title")
  String? originalTitle;

  @JsonKey(name:"overview")
  String? overview;

  @JsonKey(name:"popularity")
  double? popularity;

  @JsonKey(name:"poster_path")
  String? posterPath;

  @JsonKey(name: "production_companies")
  List<ProductionCompaniesVO>? productionCompanies;

  @JsonKey(name: "production_countries")
  List<ProductionCountriesVO>? productionCountries;

  @JsonKey(name:"release_date")
  String? releaseDate;

  @JsonKey(name: "revenue")
  double? revenue;

  @JsonKey(name: "runtime")
  int? runtime;

  @JsonKey(name: "spoken_languages")
  List<SpokenLanguagesVO>? spokenLanguages;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "tagline")
  String? tagline;

  @JsonKey(name:"title")
  String? title;

  @JsonKey(name:"video")
  bool? video;

  @JsonKey(name:"vote_average")
  double? voteAverage;

  @JsonKey(name:"vote_count")
  double? voteCount;


  MovieVO(
      this.adult,
      this.backDropPath,
      this.belongToCollection,
      this.budget,
      this.genres,
      this.homePage,
      this.genreIds,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.productionCompanies,
      this.productionCountries,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount);

  factory MovieVO.fromJson( Map<String,dynamic> json) => _$MovieVOFromJson(json);

  Map<String,dynamic> toJson() => _$MovieVOToJson(this);

  @override
  String toString() {
    return 'MovieVO{adult: $adult, backDropPath: $backDropPath, genreIds: $genreIds, id: $id, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount}';
  }
}