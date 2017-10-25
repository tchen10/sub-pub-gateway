# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create([
              { email: 'michael@abc.com',
                full_name: 'Michael Scott',
                phone_number: '1234567890',
                password: 'secret',
                key: '1',
                metadata: 'age 42, male, unemployed' },
              {
                email: 'dwight@abc.com',
                full_name: 'Dwight Shrute',
                phone_number: '555555555',
                password: 'secret',
                key: '2',
                metadata: 'age 62, male, employed'
              },
              {
                email: 'pam@abc.com',
                full_name: 'Pam Beasly',
                phone_number: '888888888',
                password: 'secret',
                key: '3',
                metadata: 'age 32, female, employed'
              }
            ])