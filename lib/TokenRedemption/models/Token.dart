class Token {
  final String name;
  final String tokenId;
  final String image;
  final String descriptioin;
  final int qty;
  final int value;
  int amount;
  final bool status;

  Token(
      {this.name,
      this.tokenId,
      this.image,
      this.descriptioin,
      this.qty,
      this.value,
      this.status,
      this.amount = 1});
}

class RedeemedToken {
  final String name;
  final String tokenId;
  final String image;
  final String descriptioin;
  final String date;
  final String time;
  final int qty;
  final int value;
  final int status;

  RedeemedToken({
    this.name,
    this.tokenId,
    this.image,
    this.descriptioin,
    this.date,
    this.time,
    this.qty,
    this.value,
    this.status,
  });
}
