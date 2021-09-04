// class PastDraws {
//   final Prizes prizes;
//   final String drawString;
//   final String date;
//   // final String winningCriteria;

//   PastDraws(
//     this.prizes,
//     this.drawString,
//     this.date,
//   );
// }

// class Prizes {
//   final String first;
//   final String second;
//   final String third;
//   final String consolation;

//   Prizes(this.first, this.second, this.third, this.consolation);
// }

class PastDraws {
  final String drawString;
  final String winningCriteria;
  final String date;
  final String time;
  final String first;
  final String second;
  final String third;
  final String drawId;

  PastDraws(this.drawString, this.winningCriteria, this.time, this.first, this.second, this.third,
      this.drawId, this.date);
}
