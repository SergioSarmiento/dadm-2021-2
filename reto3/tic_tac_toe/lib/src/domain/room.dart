class Room {
  final String id;
  final String host;
  final String guest;
  final int move;

  Room({
    required this.host,
    required this.guest,
    this.move = -2,
    this.id = '0',
  });

  Room.fromJson({
    required Map<dynamic, dynamic> json,
    required this.id,
  })  : host = json['host'].toString(),
        guest = json['guest'].toString(),
        move = json['move'] as int;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'host': host,
        'guest': guest,
        'move': move,
      };
}
