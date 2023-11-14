import { REGISTRATION_TYPE, STATUS_USER, ROLE_USER } from '../../constants';

export const users = [
  {
    createdAt: '2023-06-22 00:44:39.252582',
    updatedAt: '2023-08-26 11:52:19.621240',
    idUser: '42a2ba89-10c8-11ee-86db-0242ac150002',
    firstName: 'Francisco1',
    lastName: 'Palacios',
    dni: '08032000223',
    email: 'repartidor1@gmail.com',
    phone: '+504 95201045',
    password: '$2b$10$Tl84RS83JfQAW.Crhl5lD.QYL.m1ZHJYDwfn0w6VtIUH7uIZ11dBy', // ? Contrasena.L25
    status: STATUS_USER.ACTIVE,
    role: ROLE_USER.DELIVERY,
    parentUserIdUser: null,
    image: null,
    registrationType: REGISTRATION_TYPE.BASIC,
  },
  {
    createdAt: '2023-06-22 00:45:05.676960',
    updatedAt: '2023-08-26 11:52:19.646824',
    idUser: '5262bfed-10c8-11ee-86db-0242ac150002',
    firstName: 'Ezequiel2',
    lastName: 'Garay',
    dni: '08032000224',
    email: 'repartidor2@gmail.com',
    phone: '+504 88102036',
    password: '$2b$10$Tl84RS83JfQAW.Crhl5lD.QYL.m1ZHJYDwfn0w6VtIUH7uIZ11dBy', // ? Contrasena.L25
    status: STATUS_USER.ACTIVE,
    role: ROLE_USER.DELIVERY,
    parentUserIdUser: null,
    image: null,
    registrationType: REGISTRATION_TYPE.BASIC,
  },
  {
    createdAt: '2023-06-22 00:41:31.372905',
    updatedAt: '2023-08-26 11:52:19.660615',
    idUser: 'd2a69073-10c7-11ee-86db-0242ac150002',
    firstName: 'Angel3',
    lastName: 'Barahona',
    dni: '08032000222',
    email: 'repartidor3@gmail.com',
    phone: '+504 99630647',
    password: '$2b$10$Tl84RS83JfQAW.Crhl5lD.QYL.m1ZHJYDwfn0w6VtIUH7uIZ11dBy', // ? Contrasena.L25
    status: STATUS_USER.ACTIVE,
    role: ROLE_USER.DELIVERY,
    parentUserIdUser: null,
    image: null,
    registrationType: REGISTRATION_TYPE.BASIC,
  },
];
