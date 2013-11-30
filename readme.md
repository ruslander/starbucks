# OTP/Erlang modelling exercise

Inspired from [Starbucks Does Not Use Two-Phase Commit][1]


  [1]: http://google.comhttp://www.enterpriseintegrationpatterns.com/ramblings/18_starbucks.html  

#### Problem

Starbucks, like most other businesses is primarily interested in maximizing throughput of orders. More orders equals more revenue. As a result they use asynchronous processing. When you place your order the cashier marks a coffee cup with your order and places it into the queue. The queue is quite literally a queue of coffee cups lined up on top of the espresso machine. This queue decouples cashier and barista and allows the cashier to keep taking orders even if the barista is backed up for a moment. It allows them to deploy multiple baristas in a Competing Consumer scenario if the store gets busy.

#### Interaction 

![diagram](https://github.com/ruslander/starbucks/raw/master/doc/diag.png)

#### Messages 

	Customer->Cashier: new order
	Cashier-->Orders: order placed
	Orders->Barista: prepare
	Barista-->Barista: preparing
	Cashier->Customer: request payment
	Barista-->Barista: toss timeout
	Customer->Cashier: pay order
	Cashier-->Orders: order paid
	Orders->Barista: paid
	Barista-->Barista: done
	Note over Barista: paid & done
	Barista->Customer: drink ready
		
#### Test cases

	customer: when I'm asked to pay for coffe then I hand money to cashier
	customer: when I get my drink then I smile and say "thank you" to barista

	cashier: when a new order is placed then I ask to be paid
				and order placed gets fired
	cashier: when i get a payment then I fire the order paid 			

	orders: when order is placed then an work item is enquied
	orders: when order is paid then is marked as paid and can be handed to the customer

	barista: when barista starts working then it sends ready message to the orders dispatcher
	barista: when I get prepare then I start preparing the drink
	barista: when drink is done then if for 1 sec is not paid then I toss it 
	barista: when I get order paid then I hand it to customer 
	barista: when drink is given to customer then sends ready to orders deispatcher

### Conclusion

Implemenation is opinionated and intentionally kept as simple as posible.

### Feedback

I'm [@ruslanrusu](http://twitter.com/ruslanrusu) on Twitter.

Your feedback is highly appreciated