export interface PixelPayBody {
  customer_name: string;
  card_number: string;
  card_holder: string;
  card_expire: string;
  card_cvv: string;
  customer_email: string;
  billing_address?: string;
  billing_city?: string;
  billing_country?: string;
  billing_state?: string;
  billing_phone?: string;
  order_id: string;
  order_currency: string;
  order_amount: string;
  env: string;
  lang: string;
}
