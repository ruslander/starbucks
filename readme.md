# OTP/Erlang modelling exercise

Sample source is [Starbucks Does Not Use Two-Phase Commit][1]


  [1]: http://google.comhttp://www.enterpriseintegrationpatterns.com/ramblings/18_starbucks.html  

#### Problem

Starbucks, like most other businesses is primarily interested in maximizing throughput of orders. More orders equals more revenue. As a result they use asynchronous processing. When you place your order the cashier marks a coffee cup with your order and places it into the queue. The queue is quite literally a queue of coffee cups lined up on top of the espresso machine. This queue decouples cashier and barista and allows the cashier to keep taking orders even if the barista is backed up for a moment. It allows them to deploy multiple baristas in a Competing Consumer scenario if the store gets busy.

#### User stories

	As a customer, I want to order a coffee so that Starbucks can prepare my drink
	As a customer, I want to pay my bill to receive my drink
	As a barista, I want to know about of drinks that I need to make, so that I can serve my customers
	As a barista, I want to check that a customer has payd for their drink so I that I can serve it

#### Actor interaction 


#### Message flow 

	Starbucks Customer->Cashier: new order 
	Cashier-->Barista: order placed 
	Barista-->Barista: preparing 
	Cashier->Customer: request payment 
	Customer->Cashier: pay order 
	Cashier-->Barista: order paid 
	Barista-->Barista: done 
	Note over Barista: paid & done 
	Barista->Customer: drink ready


### Conclusion

Implemenation is opinionated and intentionally kept as simple as posible.

### Feedback

I'm [@ruslanrusu](http://twitter.com/ruslanrusu) on Twitter.

Your feedback is highly appreciated