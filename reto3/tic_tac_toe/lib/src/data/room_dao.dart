import 'package:firebase_database/firebase_database.dart';
import 'package:tic_tac_toe/src/domain/room.dart';

class RoomDao {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('rooms');

  String saveRoom(Room room) {
    final newRef = _messagesRef.push();
    newRef.set(room.toJson());
    return newRef.key.toString();
  }

  void deleteRoom(String key) {
    try {
      _messagesRef.child(key).remove();
    } catch (e) {}
  }

  Future<List<Room>> getRooms() async {
    final children = await _messagesRef.once().then(
          (value) => value.snapshot.children,
        );
    return children
        .where((element) => (element.value as Map)['guest'] == '')
        .map((e) => Room.fromJson(id: e.key!, json: e.value as Map))
        .toList();
  }

  Future<bool> enterRoom(Room room) async {
    final currRoom = await _messagesRef.child(room.id).get();

    if (currRoom.exists && (currRoom.value as Map)['guest'] == '') {
      try {
        await _messagesRef.child(room.id).update(room.toJson());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> startGame(Room room) async {
    final currRoom = await _messagesRef.child(room.id).get();
    final newRoom =
        Room(id: room.id, guest: room.guest, move: -1, host: room.host);
    if (currRoom.exists && (currRoom.value as Map)['guest'] != '') {
      try {
        await _messagesRef.child(room.id).update(newRoom.toJson());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> makeMove(int index, String key) async {
    final snapShot = await _messagesRef.child(key).get();
    if (snapShot.exists) {
      try {
        final room = Room.fromJson(json: (snapShot.value as Map), id: key);
        final newRoom =
            Room(id: room.id, host: room.host, guest: room.guest, move: index);
        await _messagesRef.child(key).update(newRoom.toJson());
      } catch (e) {}
    }
  }

  void exitRoom(Room room) async {
    try {
      final currRoom = await _messagesRef.child(room.id).get();
      if (currRoom.exists) {
        final newRoom = Room(id: room.id, host: room.host, guest: '');
        _messagesRef.child(room.id).update(newRoom.toJson());
      }
    } catch (e) {}
  }

  DatabaseReference getInstance() {
    return _messagesRef;
  }

  Query getMessageQuery() {
    return _messagesRef;
  }
}
