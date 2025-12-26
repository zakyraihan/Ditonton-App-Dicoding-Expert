abstract class MovieSearchEvent {}
class OnQueryChanged extends MovieSearchEvent {
  final String query;
  OnQueryChanged(this.query);
}