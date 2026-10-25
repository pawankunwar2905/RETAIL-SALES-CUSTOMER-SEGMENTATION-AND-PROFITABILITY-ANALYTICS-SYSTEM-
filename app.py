import pandas as pd
import streamlit as st

st.set_page_config(
    page_title="E-Commerce Analytics Hub", page_icon="📊", layout="wide"
)

st.title("E-Commerce Analytics & Recommendation Hub")
st.markdown(
    "Interactive dashboard showcasing customer segmentation and cross-selling"
    " rules."
)

st.sidebar.header("Navigation")
app_mode = st.sidebar.selectbox(
    "Choose Section",
    ["Overview", "Market Basket Analysis", "Customer Segmentation"],
)

if app_mode == "Overview":
  st.subheader("Project Summary")
  st.write("Welcome to the E-Commerce sales analytics dashboard.")

  col1, col2, col3 = st.columns(3)
  col1.metric("Total Net Sales", "$2.3M+")
  col2.metric("Total Customers", "793")
  col3.metric("Customer Segments", "VIP, Regular, At-Risk")

elif app_mode == "Market Basket Analysis":
  st.subheader("Market Basket Analysis (Apriori Rules)")
  st.write("Explore product association rules and confidence metrics.")

  data_rules = {
      "Rule_Pair": [
          "Accessories & Art -> Binders",
          "Accessories & Art -> Paper",
          "Accessories & Binders -> Art",
          "Accessories & Binders -> Phones",
      ],
      "Confidence": [0.30, 0.33, 0.17, 0.22],
      "Support": [0.01, 0.01, 0.01, 0.01],
  }
  df_rules = pd.DataFrame(data_rules)

  st.dataframe(df_rules, use_container_width=True)

  st.download_button(
      label="Download Rules Data as CSV",
      data=df_rules.to_csv(index=False),
      file_name="market_basket_rules.csv",
      mime="text/csv",
  )

  st.markdown("---")
  st.subheader("Confidence Score Graph")
  chart_data = df_rules.set_index("Rule_Pair")["Confidence"]
  st.bar_chart(chart_data)

elif app_mode == "Customer Segmentation":
  st.subheader("RFM Customer Segmentation")
  st.write(
      "Customer behavior breakdown based on Recency, Frequency, and Monetary"
      " metrics."
  )

  col1, col2, col3 = st.columns(3)
  col1.metric("Regular Customers", "473 (59.65%)")
  col2.metric("At-Risk Customers", "202 (25.47%)")
  col3.metric("VIP Customers", "118 (14.88%)")

  st.markdown("---")
  st.subheader("Customer Distribution Graph")
  rfm_chart_data = pd.DataFrame(
      {"Customer_Count": [473, 202, 118]},
      index=["Regular", "At-Risk", "VIP"],
  )
  st.bar_chart(rfm_chart_data)

  st.markdown("---")
  st.subheader("Segment Action Plan")
  segment_choice = st.selectbox(
      "Select Segment:", ["VIP", "Regular", "At-Risk"]
  )

  if segment_choice == "VIP":
    st.success(
        "Strategy: High-value customers. Offer exclusive early access and"
        " loyalty perks."
    )
  elif segment_choice == "Regular":
    st.info(
        "Strategy: Consistent buyers. Target with bundle offers to boost"
        " basket size."
    )
  elif segment_choice == "At-Risk":
    st.warning(
        "Strategy: Inactive recently. Trigger re-engagement discount campaigns."
    )