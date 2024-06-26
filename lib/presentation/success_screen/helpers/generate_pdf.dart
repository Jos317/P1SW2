import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:tecnoshopping/models/cliente_model.dart';
import 'package:tecnoshopping/models/products_model.dart';
import 'package:tecnoshopping/presentation/success_screen/helpers/save_file_mobile.dart';

Future<String> generatePDF(double total, List<Product> productPurchasedList, Cliente cliente) async {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219)));
  //Generate PDF grid.
  final PdfGrid grid = _getGrid(productPurchasedList);
  //Draw the header section by creating text element
  final PdfLayoutResult result = _drawHeader(page, pageSize, grid, total, cliente);
  //Draw grid
  _drawGrid(page, grid, result, total);

  //Save and dispose the document.
  final List<int> bytes = await document.save();
  document.dispose();
  //Launch file.
  final fileLocation =
      await FileSaveHelper.saveAndLaunchFile(bytes, 'invoice.pdf');

  return fileLocation;
}

//Draws the invoice header
PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid, double total, Cliente cliente) {
  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(91, 126, 215)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
  //Draw string
  page.graphics.drawString(
      'FACTURA', PdfStandardFont(PdfFontFamily.helvetica, 30),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(65, 104, 205)));
  page.graphics.drawString(r'Bs ' + total.toStringAsFixed(2),
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.white,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle));
  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
  //Draw string
  page.graphics.drawString('Total', contentFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  final String invoiceNumber =
      'Numero de factura: 1\r\n\r\nFecha: ' + format.format(DateTime.now());
  final Size contentSize = contentFont.measureString(invoiceNumber);
  String address =
      'Cobrar a: \r\n\r\n${cliente.name} ${cliente.last_name}, \r\n\r\nCI: ${cliente.ci}, \r\n\r\nTelefono: ${cliente.phone}';
  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));
  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 120, pageSize.width - (contentSize.width + 30),
          pageSize.height - 120))!;
}

//Draws the grid
void _drawGrid(
    PdfPage page, PdfGrid grid, PdfLayoutResult result, double total) {
  Rect? totalPriceCellBounds;
  Rect? quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
  //Draw grand total.
  page.graphics.drawString('Total(Bs)',
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10,
          quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(total.toStringAsFixed(2),
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 10,
          totalPriceCellBounds!.width,
          totalPriceCellBounds!.height));
}

//Create PDF grid and return
PdfGrid _getGrid(List<Product> productPurchasedList) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Producto Id';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Nombre del producto';
  headerRow.cells[2].value = 'Precio';
  headerRow.cells[3].value = 'Cantidad';
  headerRow.cells[4].value = 'Subtotal';
  for (int i = 0; i < productPurchasedList.length; i++){
    final product = productPurchasedList[i];
    _addProducts(product.code, product.name, product.price.toStringAsFixed(2), product.purchased, product.buy.toStringAsFixed(2), grid);
  }
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void _addProducts(String productId, String productName, String price,
    int quantity, String total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price;
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total;
}
