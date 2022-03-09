import 'package:flutter/cupertino.dart';
import 'package:module_3_movies_app/data/%20models/movie_model.dart';
import 'package:module_3_movies_app/data/vos/actors_vo.dart';
import 'package:module_3_movies_app/data/vos/genre_vo.dart';
import 'package:module_3_movies_app/data/vos/movie_vo.dart';
import 'package:module_3_movies_app/network/dataagents/dio_movie_data_agent_impl.dart';
import 'package:module_3_movies_app/network/dataagents/movie_data_agent.dart';
import 'package:module_3_movies_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:module_3_movies_app/persistence/daos/actor_dao.dart';
import 'package:module_3_movies_app/persistence/daos/genre_dao.dart';
import 'package:module_3_movies_app/persistence/daos/movie_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieModelImpl extends MovieModel {
  MovieDataAgent _dataAgent = RetrofitDataAgentImpl();

  MovieModelImpl._internal();

  static MovieModelImpl _singleton = MovieModelImpl._internal();

  MovieDao movieDao = MovieDao();
  GenreDao genreDao = GenreDao();
  ActorDao actorDao = ActorDao();

  factory MovieModelImpl() {
    return _singleton;
  }

  @override
  void getNowPlayingMovies() {
    _dataAgent.getNowPlayingMovies(1).then((movieList) async {
      List<MovieVO> nowPlayingMovies = movieList?.map((movie) {
            movie.isNowPlaying = true;
            movie.isPopular = false;
            movie.isTopRated = false;
            return movie;
          }).toList() ??
          [];
      movieDao.saveAllMovies(nowPlayingMovies);
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
      movieDao.saveAllMovies(popularMovies);
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
      movieDao.saveAllMovies(topRatedMovies);
     // return Future.value(movieList);
    });
  }

  @override
  Future<List<ActorsVO>?> getActors() {
    // return _dataAgent.getActors(1);
    return _dataAgent.getActors(1).then((actorList) async {
      actorDao.saveAllActors(actorList ?? []);
      return Future.value(actorList);
    });
  }

  @override
  Future<List<GenreVO>?> getGenres() {
    return _dataAgent.getGenres().then((genreList) async {
      genreDao.saveAllGenres(genreList ?? []);
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
        movieDao.saveSingleMovie(movie);
      }
      return Future.value(movie);
    });
  }

  //Database
  @override
  Future<List<ActorsVO>?> getActorsFromDatabase() {
    return Future.value(actorDao.getAllActors());
  }

  @override
  Future<List<GenreVO>?> getGenresFromDatabase() {
    return Future.value(genreDao.getAllGenres());
  }

  @override
  Future<List<MovieVO>?> getNowPlayingFromDatabase() {
    getNowPlayingMovies();
    return movieDao
        .getAllMovieEventStream()
        .startWith(movieDao.getNowPlayingMovieStream())
        .combineLatest(movieDao.getNowPlayingMovieStream(),
            (event, movieList) => movieList as List<MovieVO>)
        .first;
  }

  @override
  Future<List<MovieVO>?> getPopularFromDatabase() {
    getPopularMovies();
    return movieDao
        .getAllMovieEventStream()
        .startWith(movieDao.getPopularMovieStream())
        .combineLatest(movieDao.getPopularMovieStream(),
            (event, movieList) => movieList as List<MovieVO>)
        .first;
  }

  @override
  Future<List<MovieVO>?> getTopRatedFromDatabase() {
    getTopRatedMovies();
    return movieDao
        .getAllMovieEventStream()
        .startWith(movieDao.getTopRatedMovieStream())
        .combineLatest(movieDao.getTopRatedMovieStream(),
            (event, movieList) => movieList as List<MovieVO>)
        .first;
  }

  @override
  Future<MovieVO?> getMovieDetailFromDatabase(int movieId) {
    return Future.value(movieDao.getMoviesById(movieId));
  }
}
