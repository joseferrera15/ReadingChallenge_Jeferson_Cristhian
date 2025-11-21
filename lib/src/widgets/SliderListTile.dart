import 'package:flutter/material.dart';

class SliderListTile extends StatefulWidget
{
  final String title;
  final String author;
  // El Slider tiene un rango de 0 a 1, asi que haremos uso de algebra basica
  final ValueChanged<double>? onChanged;
  final Widget trailing;
  final double pagesRead; // Este es el valor actual del slider
  final double totalPages; // Este es el maximo valor del slider
  final int? divisions;

  const SliderListTile({
    Key? key,
    required this.title,
    required this.author,
    required this.pagesRead,
    this.onChanged,
    required this.trailing,
    required this.totalPages,
    this.divisions,
  }); //: super(key: key);

  @override
  _SliderListTileState createState() => _SliderListTileState();
}

class _SliderListTileState extends State<SliderListTile>
{
  late double _currentValue;

  @override
  void initState() 
  {
    super.initState();
    _currentValue = (widget.pagesRead / widget.totalPages);
  }

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text('Autor: ${widget.author} - Páginas leídas: ${(_currentValue * widget.totalPages).toStringAsFixed(0)}/${widget.totalPages.toStringAsFixed(0)}'),
      trailing: SizedBox( 
        width: 170,
        child: Row(
          children: 
          [
            Column
            (
              children: 
              [
                Text('${_currentValue}/${widget.totalPages}'),
                widget.trailing
              ]
            ),
            IconButton(onPressed: () {print('object');}, icon: Icon(Icons.navigate_next, size: 19,))
          ]
        )
        /*Slider
        (
          value: _currentValue,
          min: 0,
          max: widget.totalPages,
          divisions: widget.divisions,
          //label: '${(_currentValue * widget.totalPages).toStringAsFixed(0)}',
          onChanged: widget.onChanged != null ? (value) 
          {
            setState(() 
            {
              _currentValue = value;
            });

            widget.onChanged!(value);
          } : null,
        )*/
      ),
    );
  }
}