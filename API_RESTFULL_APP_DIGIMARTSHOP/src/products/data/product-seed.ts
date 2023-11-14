import { Category } from '../entities/category.entity';
import { STATUS_CATEGORY } from 'src/constants/status/status.category';

interface InterfaceProduct {
  name: string;
  price: number;
  discount: number;
  image: string;
  description: string;
  category: Category;
}

const category1 = {
  idCategory: 'c2b9f17b-02ef-11ee-8568-0242ac150002',
  name: 'Abarrotes',
  description: '',
  image: '',
  discount: 0,
  status: STATUS_CATEGORY.ACTIVE,
  createdAt: null,
  updatedAt: null,
};

const category2 = {
  idCategory: 'c2b9fa15-02ef-11ee-8568-0242ac150002',
  name: 'Refrescos',
  description: '',
  image: '',
  discount: 0,
  status: STATUS_CATEGORY.ACTIVE,
  createdAt: null,
  updatedAt: null,
};

const category3 = {
  idCategory: 'c2b9fd25-02ef-11ee-8568-0242ac150002',
  name: 'Carnes y Embutidos',
  description: '',
  image: '',
  discount: 0,
  status: STATUS_CATEGORY.ACTIVE,
  createdAt: null,
  updatedAt: null,
};

export const arraySeedProducts: InterfaceProduct[] = [
  {
    name: 'Harina de trigo doña blanca (454 G)',
    price: 13,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931436/product/HarinaDeTrigoDonaBlanca454Gr_bwozul.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Chile de olancho añejo (4.5 ONZ)',
    price: 25,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931490/product/chile-olancho_glmlm5.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Pasta de tomate naturas 100 G',
    price: 20,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931542/product/pastatomate_a9quqv.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Empanizador don julio (5 ONZ)',
    price: 30,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931649/product/EmpanizadorDonJulioCondimentado5Oz_kgzzaw.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Sopa instantanea de pollo laky men',
    price: 15,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931705/product/SOPALAKY_i1oaon.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Avena molida quaker (310 G)',
    price: 32,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931762/product/5.AvenaQuakerMolida310Gr_fiaevi.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Ketchup naturas (106 G)',
    price: 11,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931805/product/20.SalsaDeTomateNaturasKetchup106Gr_cltxo6.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Mayonesa hellmanns doy pack (190 G)',
    price: 35,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931876/product/Hellmanns_20Mayonesa_20Doypack_20200g-500x500_onddee.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  {
    name: 'Coditos mi pasta (200 G)',
    price: 35,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685931950/product/CoditoMiPasta200Gr_mbeb6j.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category1,
  },
  // CATEGORIA 2
  {
    name: 'Refresco coca cola original (2 L)',
    price: 50,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932071/product/00750105530292L_cfwzcr.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category2,
  },
  {
    name: 'Te lipton sabor a limon (2 Lt)',
    price: 50,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932108/product/TeFrioLiptonSaborALimon2Lt_ubr0ly.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category2,
  },
  {
    name: 'Refresco tropical banana (1.25 Lt)',
    price: 32,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932153/product/Disenosintitulo_6_tdaell.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category2,
  },
  {
    name: 'Cocacola lata (6 U)',
    price: 83.5,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932205/product/Disenosintitulo_7_yvctzp.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category2,
  },
  {
    name: 'Refresco 7Up (2 Lt)',
    price: 50,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932325/product/Disenosintitulo_10_n44ay6.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category2,
  },
  // CATEGORIA 3
  {
    name: 'Pollo rey sin menudo',
    price: 153.3,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932446/product/pollo-rey_rlvm21.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category3,
  },
  {
    name: 'Jamon bavaria delicia (247 G)',
    price: 32,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932461/product/delicia-chorisos_sb6vjn.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category3,
  },
  {
    name: 'Medallones pollo rey 20U (400 G)',
    price: 75,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932461/product/medallones_vryirp.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category3,
  },
  {
    name: 'Chorizo de cerdo cervecero progcarne (360 G)',
    price: 120,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932461/product/chorizo-cervecero_wojian.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category3,
  },
  {
    name: 'Pechuga de pollo desguesada fresco (1LB)',
    price: 78,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932461/product/pechuga-de-pollo-deshuesada_gweh2a.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category3,
  },
  {
    name: 'Chorizo delicia casero (370 G)',
    price: 28,
    discount: 0,
    image:
      'https://res.cloudinary.com/dd6htvamy/image/upload/v1685932460/product/chorizo-casero_gloibk.webp',
    description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
    category: category3,
  },
];
