class Pedido {
  final String id;
  final DateTime createdAt;
  final String customerName;
  final String description;
  final bool finished;

  Pedido({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.description,
    required this.finished,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      customerName: json['customerName'] ?? '',
      description: json['description'] ?? '',
      finished: json['finished'] ?? false,
    );
  }
}
