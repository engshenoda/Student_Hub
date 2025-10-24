part of 'career_industry_cubit.dart';

@immutable
sealed class CareerIndustryState {}

final class CareerIndustryInitial extends CareerIndustryState {}
final class CareerIndustryLoading extends CareerIndustryState {}
final class CareerIndustryLoaded extends CareerIndustryState {
  final String selectedIndustry;
  CareerIndustryLoaded(this.selectedIndustry);
}
final class CareerIndustryError extends CareerIndustryState {
  final String message;
  CareerIndustryError(this.message);
}
