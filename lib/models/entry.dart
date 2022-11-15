class Entry {
  DateTime created_at;

  Entry(this.created_at);

  Entry clone() {
    return Entry(created_at);
  }
}