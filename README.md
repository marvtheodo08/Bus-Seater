# Bus Seater
Welcome to Bus Seater, the world's first school bus seating app!
## How it works
There are 3 types of accounts:
- Student Account
- Driver Account
- Admin Account

A student account allows a student to pick their seat for the week, a driver account allows a driver to oversee the students on their bus (They don't even need to add the students themselves!), and an admin account allows a school admin to oversee all the buses and students.

When a user signs up, they have the option to sign up for any account type. But, when a user signs up for a student account, there is an authetication process to verify if the info is true, specifcally their first and last name, their grade level, their school (using the school id), and their bus (using the bus id). Once everything is verified, they are able to pick their seat for the following week. Anything account related, such as creation and login, is handled with FirebaseAuth, but user data, such as their first and last name, email, school id, and account type, will be added to a MySQL database once the account is created.

The student is able to pick their seat for the following between the Friday before the week at 4pm until the following Sunday at 8pm. On weeks that are on breaks, they are not able to pick their seats for the week.

A strike system keeps the student in check so they can still pick their seats. If the student does mischief, the driver for that student's bus can give that student a strike, and they will not be able to pick their seat for the following week. After three stikes, the student can not pick their seat for the rest of the quarter! After the quarter, however, their strikes resets back to 0 using a cron-job, which runs every day.

The admin can set up breaks and the quarters, and they are able to create buses as well and add students to buses using their first and last name, and grade level.

This app ensures that everyone has a seat they are happy in without rushing the bus, and helps create a healthy, behaved enviroment for everyone on the bus.

The app was coded entierly with Swift, with SwiftUI being its core user interface. The backend API uses Python and MySQL as its core backbone.
