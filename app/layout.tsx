import type { Metadata } from "next";
import { CartProvider } from "@/components/cart-context";
import "./globals.css";

export const metadata: Metadata = {
  title: "VERTEX ATHLETIC - Reach Your Peak",
  description: "Performance meets sustainability. Shop premium athletic footwear and gear for outdoor enthusiasts and urban athletes.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <CartProvider>
          {children}
        </CartProvider>
      </body>
    </html>
  );
}
