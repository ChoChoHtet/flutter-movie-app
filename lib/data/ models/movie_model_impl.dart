import 'package:flutter/cupertino.dart';
import 'package:module_3_movies_app/data/%20models/movie_model.dart';
import 'package:module_3_movies_app/data/vos/actors_vo.dart';
import 'package:module_3_movies_app/data/vos/genre_vo.dart';
import 'package:module_3_movies_app/data/vos/movie_vo.dart';
import 'package:module_3_movies_app/network/dataagents/movie_data_agent.dart';
import 'package:module_3_movies_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:module_3_movies_app/persistence/daos/actor_dao.dart';
import 'package:module_3_movies_app/persistence/daos/genre_dao.dart';
import 'package:module_3_movies_app/persistence/daos/impl/actor_dao_impl.dart';
import 'package:module_3_movies_app/persistence/daos/impl/genre_dao_impl.dart';
import 'package:module_3_movies_app/persistence/daos/impl/movie_dao_impl.dart';
import 'package:module_3_movies_app/persistence/daos/movie_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieModelImpl extends MovieModel {
  MovieDataAgent _dataAgent = RetrofitDataAgentImpl();

  MovieModelImpl._internal();

  static MovieModelImpl _singleton = MovieModelImpl._internal();

  MovieDao mMovieDao = MovieDaoImpl();
  GenreDao mGenreDao = GenreDaoImpl();
  ActorDao mActorDao = ActorDaoImpl();

  /// Only For Test
  @visibleForTesting
  void setDaoAndAgentTest(
      MovieDao movieDao,
      GenreDao genreDao,
      ActorDao actorDao,
      MovieDataAgent dataAgent
      ){
    mMovieDao = movieDao ;
    mActorDao = actorDao;
    mGenreDao = genreDao;
    _dataAgent = dataAgent;
  }

  factory MovieModelImpl() {
    return _singleton;
  }

  @override
  void getNowPlayingMovies(int page) {
    _dataAgent.getNowPlayingMovies(page).then((movieList) async {
      List<MovieVO> nowPlayingMovies = movieList?.map((movie) {
            movie.isNowPlaying = true;
            movie.isPopular = false;
            movie.isTopRated = false;
            return movie;
          }).toList() ??
          [];
      mMovieDao.saveAllMovies(nowPlayingMovies);
      debugPrint("Now Playing: ${movieList.toString()}");
     // return Future.value(movieList);
    });
  }

  @override
  void getPopularMovies() {
    _dataAgent.getPopularMovies(1).then((movieList) async {
      List<MovieVO> popularMovies = movieList?.map((movie) {
            movie.isNowPlaying = false;
            movie.isPopular = true;
            movie.isTopRated = false;
            return movie;
          }).toList() ??
          [];
      mMovieDao.saveAllMovies(popularMovies);
      //return Future.value(movieList);
    });
  }

  @override
  void getTopRatedMovies() {
    _dataAgent.getTopRatedMovies(1).then((movieList) async {
      List<MovieVO> topRatedMovies = movieList?.map((movie) {
            movie.isNowPlaying = false;
            movie.isPopular = false;
            movie.isTopRated = true;
            return movie;
          }).toList() ??
          [];
      mMovieDao.saveAllMovies(topRatedMovies);
     // return Future.value(movieList);
    });
  }

  @override
  Future<List<ActorsVO>?> getActors() {
    // return _dataAgent.getActors(1);
    return _dataAgent.getActors(1).then((actorList) async {
      mActorDao.saveAllActors(actorList ?? []);
      return Future.value(actorList);
    });
  }

  @override
  Future<List<GenreVO>?> getGenres() {
    return _dataAgent.getGenres().then((genreList) async {
      mGenreDao.saveAllGenres(genreList ?? []);
      return Future.value(genreList);
    });
  }

  @override
  Future<List<MovieVO>?> getMoviesByGenreId(int genreId) {
    return _dataAgent.getMoviesByGenreId(genreId);
  }

  @override
  Future<List<List<ActorsVO>?>> getMovieCredit(int movieId) {
    return _dataAgent.getMovieCredit(movieId);
  }

  @override
  Future<MovieVO?> getMovieDetails(int movieId) {
    return _dataAgent.getMovieDetails(movieId).then((movie) async {
      if (movie != null) {
        mMovieDao.saveSingleMovie(movie);
      }
      return Future.value(movie);
    });
  }

  //Database
  @override
  Future<List<ActorsVO>?> getActorsFromDatabase() {
    debugPrint("actor list: ${mActorDao.getAllActors()}");
    return Future.value(mActorDao.getAllActors());
  }

  @override
  Future<List<GenreVO>?> getGenresFromDatabase() {
    return Future.value(mGenreDao.getAllGenres());
  }

  @override
  Stream<List<MovieVO>?> getNowPlayingFromDatabase(int page) {
    getNowPlayingMovies(page);
    return mMovieDao
        .getAllMovieEventStream()
        .startWith(mMovieDao.getNowPlayingMovieStream())
        .map((event) => mMovieDao.getNowPlayingMovies());
  }

  @override
 Stream<List<MovieVO>?> getPopularFromDatabase() {
    getPopularMovies();
    return mMovieDao
        .getAllMovieEventStream()
        .startWith(mMovieDao.getPopularMovieStream())
        .map((event) => mMovieDao.getPopularMovies());
  }

  @override
  Stream<List<MovieVO>?> getTopRatedFromDatabase() {
    getTopRatedMovies();
    return mMovieDao
        .getAllMovieEventStream()
        .startWith(mMovieDao.getTopRatedMovieStream())
        .map((event) => mMovieDao.getTopRatedMovies());
  }

  @override
  Future<MovieVO?> getMovieDetailFromDatabase(int movieId) {
    return Future.value(mMovieDao.getMoviesById(movieId));
  }
}
