.. aqPython documentation master file, created by
   sphinx-quickstart on Sun Jan 31 11:47:10 2010.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to aqPython's documentation!
====================================

aqPython is a `Python  <http://www.python.org/>`_ wrapper for `aqbanking <http://www.aqbanking.de/>`_,
a free library for online banking.

.. _getting_started:

Getting started
_______________

This section describes what steps needs to be taken to use aqPython.

Prerequisite
++++++++++++
In order to use aqPython you need a recent installation of aqbanking. ApPython does not include any
functionality to manage backends, accounts and users. Therefor all this stuff needs to be setup by
annother application like aqbanking-cli or qBankManager.

Installation
++++++++++++
The following steps are needed to install aqPython:
    * extract aqPython.tar.gz and switch into this dir
    * run "python setup.py build" (there should be warnings but no errors)

Usage
+++++
This section describes the steps for getting an accounts balance.

First switch to the aqPython dir if aqPython is not in the sys.path of your python installation::

    cd build/lib.<your python version>

Then start python and import aqPython::

    python
    >>> import aq		

Now we need to create the Banking instance ::

    >>> banking = aq.Banking()
    
From this banking instance we can access users and accounts and execute jobs.
Let's get the first account to check its balance. ::

    >>> account = banking.GetAccounts()[0]

All objects of aqPython build a treelike structure, so that the banking instance is the parent
of the account. Therefor the banking instance will not be freed, as long as we have a reference
to the account or the banking instance itself.

The next Step is to create the jobList, which is like a basket for jobs which are executed together.
We only need one job to get the balance of our account. ::

    >>> jobList = aq.JobList()
    >>> jobList.append(account.NewJobGetBalance())

Now execute the Joblist, save the result context ::
    
    >>> ctx = banking.ExecuteJobs(jobList)
    
and get the current balance. ::

    >>> accountInfo = ctx.GetAccountInfos()[0]
    >>> accountStatus = accountInfo.GetAccountStatus()[0]
    >>> accountStatus.GetBookedBalance().GetValue()

.. _api_doc:

Api documentation
_________________

.. autoclass:: aq.Banking
   :members:
   :undoc-members:

.. autoclass:: aq.User
   :members:
   :undoc-members:

.. autoclass:: aq.Account
   :members:
   :undoc-members:

.. autoclass:: aq.JobList
   :members:
   :undoc-members:

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

