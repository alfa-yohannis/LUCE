from ..luce_vm.luce_django.luce.accounts import UserManager

# Query ganache to get the privatepublic keys for the users to create

UserManager.create_user('requester@luce.com', 'Requester first name', 'Requester last name', 'Institute of Data Science', 
    ethereum_public_key=None, ethereum_private_key=None, password='requester', is_staff=True, is_admin=False)

UserManager.create_user('provider@luce.com', 'provider first name', 'provider last name', 'Institute of Data Science', 
    ethereum_public_key=None, ethereum_private_key=None, password='provider', is_staff=False, is_admin=True) 