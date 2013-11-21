
![diagram](https://github.com/ruslander/starbucks/raw/master/doc/diag.png)

The diagramed with http://bramp.github.io/js-sequence-diagrams/

Title: Starbucks
Customer->Cashier: new order
Cashier-->Barista: order placed
Barista-->Barista: preparing
Cashier->Customer: request payment
Customer->Cashier: pay order
Cashier-->Barista: order paid
Barista-->Barista: done
Note over Barista: paid & done
Barista->Customer: drink ready
