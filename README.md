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
  * accepted                 -> Meaning the request has been accepted into Nous Travaillons (boolean)
  * que_number               -> The position in which the request stands
  
That being said, the only thing you need to do to create a request, is in your console type something like this

`Request.create(
  email: alejandro@shell.com,
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33 123456789',
  first_name: "Alejandro",
  last_name: "Huertas",
)

Now, notice that the **confirmed** **accepted** **que_number** are not specified in the block of code above. That's because the first two default to false, and the third aspect, we will cover when we get to class and instance methods.  
 
  
  
  
  




