# Nous Travaillons
This is a simulation of a wating list for customers wanting to join the Nous Travaillons co-working space

The way it works is as follows. The current co-working building has a maximum of 20 workstations in which the clients can work. The problem is that this amazing place has a huge demand, so people want to be put in a waiting. This means that as soon as someone leaves, the first one in the que would be invited to come in and be part of Nous Travaillons.

To keep the pace moving for the que. Every day mails would be sent to the people who have a contract that would expire in 7 days (next week), asking them if they want to renew it. If the time expires, this contract would be terminated and everyone in the que would move up one position. 

As soon as contracts get cancelled, another mail would be sent to the people that are now eligible that were waiting in que. This people will have a 1 week period to sign a contract with Nous Travaillons, other wise they would be disregarded, and the next person in line will have priority repeating this step. 

When the ques are very long, people might have to wait a year or more in order to be concidered to join Nous Travaillons. Therefore Every day, Nous Travalions will check for the requests that will have a waiting period of 3 months next week and send a mail to the people that made this request asking them if they are still interested. If the 3 months pass without a confirmation from the request holder, they will be taken out of the que. 


# Code

Creating a Request
----------------

So to create a request, the following attributes were taking under concideration: 
  * first_name and last_name -> tells us who made it (string)
  * email                    -> tells us who do we need to send a mail to (string)
  * bio and phone_number     -> sugar for the challenge (strings)
  * confirmed                -> Let's us know if the user has clicked still interested when the 3 monts are about to come, or just confirmed his email upon                                    request creation (boolean)
  * expired                  -> Let's us know if the request is out of the que or not (boolean)
  * expiery_date             -> The date in which the request will be taken out of the line if not confirmed (date)
  * accepted                 -> Meaning the request has been accepted into Nous Travaillons (boolean)
  * que_number               -> The position in which the request stands
  
That being said, the only thing you need to do to create a request, is in your console type something like this

```ruby
Request.create(
  email: alejandro@shell.com,
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33 123456789',
  first_name: "Alejandro",
  last_name: "Huertas",
)
```
Now, notice that the **confirmed**, **accepted** **expiery_date**, and **que_number** are not specified in the block of code above. That's because the first two default to false, the third one defaults to 3 months from the momment of creation and the third aspect, will be explained in the next Section

Request Instance Methods and callback
-----------------------

We only have one callback in this method named `send_confirmation_email` which is triggered `after_create` of each instance. This callback will trigger the mailer `RequestMailer` on the action `confirmation` sending a confirmation mail which you can edit in `app/views/request_mailer/confirmation.html.erb`

When the mail has been recieved, the user has the option to click on a link that will trigger the route `email_confirmation`. This route has the purpose of changin the instance confirmed attribute to `true` and assign a que_number. This leads us to our first instance method. 

The `assign_que_number` method asks the data base first if its empty of requests. If it is, it will assign the request with a que_number of 1. Otherwise it will query the database for the highest que_number within our requets and assign that one plus one
``` ruby
def assign_que_number
  if Request.all.empty?
    self.que_number = 1
  else
    self.que_number = Request.maximum(:que_number) + 1
  end
end
```

The second method I want to speak about is `renew_expiery_date`. This method gets triggered as soon as a user clicks on the link inside the `request_renewall_confirmation` mail telling us that they are still intered in being part of the que (this mail is being sent through a `rake task` :skip to the bottom of this read me:). In the signal flow, we can see that this method is being called in the `email_confirmation` method inside the `requests_controller` Where the expiery date of the confirmed request will be moved back 30 days from the momment the user clicked on the confirmation link. 

```ruby
#controller
  def email_confirmation
    @request.confirm!
    @is_old_request = @request.has_que_number
    @request.assign_que_number unless @request.has_que_number
    @request.renew_expiery_date
    @request.save
  end
 
 #model
 def renew_expiery_date
    self.expiery_date = Date.today.next_month(3)
  end
```

if you take a look, inside that controller action we have another method that is being used to set the value of the instance variable `@is_old_request`. The `has_que_number` checks if is the renewall of an old request or a new request by determing weather it has a que_number or not. Some requests may have que_number assign to nil because if the request it's completly new and hasn't been confirmed, we don't want to git it a spot in the que over users that take it seriously and confirm the mail as soon as they get it. 

This instance variable is used to display information accordingly when a request is newly_confirmed/confirmed
```ruby
<h1>Thank you so mutch. You're request has been confirmed!</h1>

<% if @request.que_number > @max_capacity %>

  <% if @is_old_request %>

    <p>Thanks for still being interested in our service</p>
    <p>We will keep you posted as soon as there is space for you</p>

  <% else %>

    <p>Currently our office is full, and as soon as we have space for you wi will let you know</p>

  <% end %>

  <p>Your current number in the waiting list is <%= @request.que_number - @max_capacity %> </p>
  <%= link_to 'Home', root_path  %>

<% else %>

  <p>Congratualions! You are eligible to take part of the nous travaillons expirience</p>
  <%= link_to "I understand the legal terms of the contract and I want to sign it", request_contracts_url(@request), method: :post  %>

<% end %>
```

In the example above you can notice that the app has different messages depending on the type of request `new/old`. And thats it for the instance methods the rest are very self explainatory and you can check them out in the `Request.rb` file. Now let's move to what happens with the contracts as soon as a request is eligible to be part of the Nous Travallions family. 


Contract Instance methods
----------------------


At the end of that previous code snipet you can see that there is a link that goes to an endpoint which creates a contract associated with that request. 
This were the attributes chosen for this model. 

* expiery_date             -> The date in which the contract will be expired if not confirmed and a new spot will be available for the people standing in the que (date)

* expired --> This let's us know that the contract is no longer valid (boolean)
    
   
* provisional -> This let's us know if the contract has ben sent to someone on the que_line that just got acces to the first 20. When a contract is provisional, the expiery_date is not set to the next month like the other normal contracts, but for the next week. This way if the spot is not confirmed, we can move the que faster. (boolean)
   
* confirmed -> Meaning that the contract is valid and the expiery_date will be posponed (boolean)
* request_id -> Reference to the request that got accepted with the details of the user. 

And this were the instance methods used for this class

```ruby
def expire!
    self.expired = true
  end

  def provisional?
    self.provisional
  end

  def confirm!
    self.confirmed = true
  end

  def renew_expiery_date!
    self.expiery_date = self.expiery_date.next_month
    self.provisional = false
  end

  def unconfirm!
    self.confirmed = false
  end

  def self.expires_next_week
    next_week = Date.today + 7
    Contract.where(expiery_date: next_week, provisional: false, confirmed: true)
  end

  def self.valid_contracts
    Contract.where(provisional: false)
  end

  def self.today_expires_and_unconfirmed
    Contract.where(expiery_date: Date.today, confirmed: false, expired: false)
  end
```

which are self explainatory. If you remember on the view code snipet, you saw the route to create a Contract. so let's take a look at that. 
```ruby
 def create
    @contract = Contract.new(expiery_date: Date.today.next_month)
    @contract.request = @request
    @contract.save!

    @request.accept!
    @request.save
  end
```

as you can see a contract gets automatically created with the expiery_date set to a month from when the user signed the contract and assigns the corresponding request to the contract.

The second controller method is the renewal_confirmation
```ruby
def renewal_confirmation
  @new_contract = @contract.provisional
  @contract.confirm!
  @contract.renew_expiery_date!
  @contract.save
end
```

in there we also do the little is old record but this time not by checking the que_number, but by checking if the contract is provisional or not. So what does this provisional mean again? It means that when a user has left the company, We send mail automatically to the people next inline with a provisional contract already being created waiting confirmation form them. So if a new person confirms their provisional contract, then the welcome message should be more exciting than to the person that has an old contract. And here is how the view looks like for this signal flow.

```ruby
<% if @new_contract %>
  <h1>Welcome to Nous Travallions!</h1>
  <p>On behalf of the team we welcome you to this wonderfull comunity!</p>
<% else %>
  <h1>Thank you so much!</h1>
  <p>We look forward to keep working with you</p>
<% end %>
```


# Tasks

Now here is where the magic happens in order to keep the que line going and the mails flowing. The app counts with three dailey tasks set by heroku scheduler. The first one `requests:send_renewal_email`, the second one `contracts:send_renewal_email`, and the third one `contracts:mark_expired`

requests:send_renewal_email
----------------

```ruby
requests = Request.unaccepted_and_still_interested
puts "Enqueuing confirmation of #{requests.count} requests..."
requests.each do |request|
  request.confirmed = false
  request.save
  RequestMailer.with(request: request).request_renewal_confirmation.deliver_now
end
```
what this task does, is it calls upon the Request class method `unaccepted_and_still_interested` which returns an array of instances with the attributes `expired` and `accepted` set to false where their expiery date is next week. and then for each and one of them, it sends a mail calling again the mailer `RequestMailer` in the action `request_renewal_confirmation` 


contracts:send_renewal_email
------------

This one is very similar than the provious one the only difference is that we are basing our mail sending based on contracts that are about to expire, instead of requests

```ruby
contracts = Contract.expires_next_week
puts "Enqueuing confirmation of #{contracts.count} contracts..."
contracts.each do |contract|
  contract.unconfirm!
  contract.save
  ContractMailer.with(contract: contract).contract_renewal_confirmation.deliver_now
end
```

contracts:mark_expired
-----------

And for last we have the third one which changes a little from the other two, since this time we don't have to only send a mail to records with a specic state, but we also need to recalculate the que_numbers for the entire que
```ruby
contracts = Contract.today_expires_and_unconfirmed
    puts "Enqueuing expiery of #{contracts.count} contracts..."
    contracts.each do |contract|
      contract.expire!
      contract.save
      request = contract.request
      request.remove_from_que!
      request.unaccept!
      request.unconfirm!
      request.expire!
      request.save
      ContractMailer.with(contract: contract).contract_expired.deliver_now
    end
    Request.calculate_que_number
  end
```

So as you can see the beguining is still the same as the other two. We change the value of the attributes of the record and then we send a mail. Now the meat comes in the Request class method `calculate_que_number` and this is how it looks

```ruby
def self.calculate_que_number
  requests = Request.not_expired.order(:que_number)
  Request.reassign_que_numbers(requests)
  new_requests = Request.where(accepted: false).where("que_number <= 20")
  Request.send_contract_to_new_accepted_requests(new_requests)
end
```

so the functionality is split into 2 parts, the first one is recalculating the que numbers, and the second one is sending a mail to the people that were in cue and because of some contracts expirations, they are now elligible to sign one themselves.

So the first two lines we get all the requests that aren't expired, and we sort them by their que_number. Since there maybe requests that left, the order of this might not be one by one, but sometimes it can have jumps. So in order to ensure that we have each request with a step of one between que_numbers, we call `the reassign_que_numbers` class method with the argument of our previous database query. This method looks like this. 
```ruby
def self.reassign_que_numbers(requests)
  requests.each_with_index do |request, index|
    request.que_number = index + 1
    request.save
  end
end
```

And as you can see we just reassign que_numbers based on their index. This way we avoid que_number jumps.

The second part of the method, is The sending of the mail of the people that were in line that now are available.
```ruby
def self.send_contract_to_new_accepted_requests(new_requests)
  new_requests.each do |request|
    if request.contract.nil?
      RequestMailer.with(request: request).send_contract.deliver_now
      provisional_contract = Contract.new(expiery_date: Date.today + 7, confirmed: false, provisional: true)
      provisional_contract.request = request
      provisional_contract.save
    end
  end
end
```

so what happens here is that first we iterate over the array new_requests, if you recall from the parent method, you'll see that new_requests are requests under the max_capacity que_number, that havn't been accepted. So what we do here is first we check if the request has a provisional contract, meaning that this new request has already been sent the mail to sign a contract. If there is no provisional contract attached to this request, means that the request is completly new, and we create a provisional contract associated with that request. Note that the expiery date is set to 7 days after the mail has been sent and the provisional attribute is set to true. This will change if the user confirms the link sent in the mail in the first line of that if statement. 



# Tests

In order to run the tests of the app you need to have rspec installed in your machine and run the following command `rspec spec`

You will find the tests inside the spec folder with test the mail sending and the validity of instances.

# Production

This demo is used with the `letter-opener-web` which enable us to preview the mails that will be sent. There is no actual domain that sends actual emails. Eventhough the server acts like if there were emails being sent to diffrent email addresses, there are none. 

In order to see the previews you need to go to the endpoint `/letter_opener`

# Disclaimers
1 Unfortunatly the gem doesn't work with background jobs running in your app but,  feel free to cantact me if you want the version with this incorporated.

2 The gem also picks up emails that were sent from the app after an http request. Therefore the gem won't work using tasks. For this workarround I created a Task controller with each task corresponding to 1 action. This way I can by pass it and the preview will still work. If you use the tasks the way they are supposed to, you will see in your server the mails being sent, but the preview won't be available.






  
  
  
  




